## Not released

## 1.0.0

Breaking changes:
- Update faraday to 2.0

## 0.5.0

Breaking changes:
- [ingestion] Added source argument to `ingest` method

## 0.4.0

Breaking changes:
- [ingestion] move event_code to payload

## 0.3.0

Breaking changes:
- [ingestion] replace basic auth with token based authentication
- [ingestion] changed singnature from keywords to arguments in `ingest` method
- [ingestion] removed username from client constructor
- [ingestion] removed password from client constructor
- [ingestion] removed account_id from client constructor
- [ingestion] removed HMAC key from client constructor
- [ingestion] removed provider key from client constructor

## 0.2.0

- [ingestion] added `event.payload.event_id` to prevent events duplication on Ubersicht side
- [ingestion] added `event.payload.event_id` to event signature
- [ingestion] added `debug` option to ingestion client. If false then request will be ran in a new thread.

Breaking changes:

- [ingestion] replaced `ingest` signature to keywords
- [ingestion] renamed `event.type` with `event.transaction_type`
- [ingestion] replaced `clien.ingest_events(events)` with `clien.ingest(event)`

## 0.1.0

- [ingestion] added Ubersicht::Ingestion::Client#ingest_events
- [ingestion] added signature to event payload, `payload.signature`
- [ingestion] added validaton of event type based on types allowed for provider
