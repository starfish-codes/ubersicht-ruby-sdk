## Not released

- [ingestion] added `event.payload.event_id` to prevent events duplication on Ubersicht side
- [ingestion] added `event.payload.event_id` to event signature

Braking changes:

- [ingestion] moved `event.transaction_id` to `event.transaction.event_group_id`
- [ingestion] renamed `event.type` with `event.transaction_type`
- [ingestion] replaced `clien.ingest_events(events)` with `clien.ingest(event)`

## 0.1.0

- [ingestion] added Ubersicht::Ingestion::Client#ingest_events
- [ingestion] added signature to event payload, `payload.signature`
- [ingestion] added validaton of event type based on types allowed for provider
