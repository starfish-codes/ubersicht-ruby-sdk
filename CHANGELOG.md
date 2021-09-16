## Not released
## 0.2.0

- [ingestion] added `event.payload.event_id` to prevent events duplication on Ubersicht side
- [ingestion] added `event.payload.event_id` to event signature
- [ingestion] added `debug` option to ingestion client. If false then request will be ran in a new thread.

Braking changes:

- [ingestion] replaced `ingest` signature to keywords
- [ingestion] renamed `event.type` with `event.transaction_type`
- [ingestion] replaced `clien.ingest_events(events)` with `clien.ingest(event)`

## 0.1.0

- [ingestion] added Ubersicht::Ingestion::Client#ingest_events
- [ingestion] added signature to event payload, `payload.signature`
- [ingestion] added validaton of event type based on types allowed for provider
