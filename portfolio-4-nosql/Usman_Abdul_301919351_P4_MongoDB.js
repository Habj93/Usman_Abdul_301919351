// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("transaction_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("transaction_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "transaction_created",
                    "transaction_posted"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "transactions"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "txn_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("transaction_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transaction_created",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "transactions",
            "key": {
                "txn_id": 301
            },
            "snapshot": {
                "txn_id": 301,
                "account_id": 201,
                "occurred_at": "2025-02-01T10:30:00Z",
                "amount": 125.5,
                "direction": "inflow",
                "status": "posted",
                "external_ref": "SYN-REQUEST-001"
            }
        },
        "embedded": {
            "accounts": [
                {
                    "key": {
                        "account_id": 201
                    },
                    "snapshot": {
                        "account_id": 201,
                        "account_ref": "SYN-ACCOUNT-001",
                        "type_id": 101,
                        "currency": "USD",
                        "opened_on": "2025-01-15",
                        "status": "active"
                    },
                    "via": [
                        "transactions.account_id → accounts"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transaction_posted",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "transactions",
            "key": {
                "txn_id": 301
            },
            "snapshot": {
                "txn_id": 301,
                "account_id": 201,
                "occurred_at": "2025-02-01T10:30:00Z",
                "amount": 125.5,
                "direction": "inflow",
                "status": "posted",
                "external_ref": "SYN-REQUEST-001"
            }
        },
        "embedded": {
            "accounts": [
                {
                    "key": {
                        "account_id": 201
                    },
                    "snapshot": {
                        "account_id": 201,
                        "account_ref": "SYN-ACCOUNT-001",
                        "type_id": 101,
                        "currency": "USD",
                        "opened_on": "2025-01-15",
                        "status": "active"
                    },
                    "via": [
                        "transactions.account_id → accounts"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "provider_metadata": "illustrative provider_metadata",
                "decision_details": "illustrative decision_details"
            }
        }
    }
]));
  await db.getCollection("transaction_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("transaction_events").find({"eventType":"transaction_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("transaction_events").find({"source.key.txn_id":301}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("transaction_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("transaction_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("transaction_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "transaction_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "transactions",
        "key": {
            "txn_id": 301
        },
        "snapshot": {
            "txn_id": 301,
            "account_id": 201,
            "occurred_at": "2025-02-01T10:30:00Z",
            "amount": 125.5,
            "direction": "inflow",
            "status": "posted",
            "external_ref": "SYN-REQUEST-001"
        }
    },
    "embedded": {
        "accounts": [
            {
                "key": {
                    "account_id": 201
                },
                "snapshot": {
                    "account_id": 201,
                    "account_ref": "SYN-ACCOUNT-001",
                    "type_id": 101,
                    "currency": "USD",
                    "opened_on": "2025-01-15",
                    "status": "active"
                },
                "via": [
                    "transactions.account_id → accounts"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("transaction_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "transaction_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "transactions",
        "key": {
            "txn_id": 301
        },
        "snapshot": {
            "txn_id": 301,
            "account_id": 201,
            "occurred_at": "2025-02-01T10:30:00Z",
            "amount": 125.5,
            "direction": "inflow",
            "status": "posted",
            "external_ref": "SYN-REQUEST-001"
        }
    },
    "embedded": {
        "accounts": [
            {
                "key": {
                    "account_id": 201
                },
                "snapshot": {
                    "account_id": 201,
                    "account_ref": "SYN-ACCOUNT-001",
                    "type_id": 101,
                    "currency": "USD",
                    "opened_on": "2025-01-15",
                    "status": "active"
                },
                "via": [
                    "transactions.account_id → accounts"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("transaction_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
