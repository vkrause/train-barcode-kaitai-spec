meta:
  id: barcode_mav
  title: MÁV domestic ticket barcode
  endian: be
  encoding: UTF-8
  license: CC0-1.0

doc: |
  MÁV ticket barcodes versions 4-6.

seq:
  - id: version
    type: u1
  - id: signing_key
    type: u1
  - id: ticket_number
    type: str
    size: 18
    if: version > 4
  - id: issuer
    type: str
    size: 4
    if: version > 4
  - id: content
    type: compressed_content
    process: zlib
    size-eos: true

types:
  compressed_content:
    seq:
      - id: header
        type: header
      - id: person_block
        type: person_block
        if: header.flags.person_block_present == true
      - id: trip_block
        type: trip_block
        if: header.flags.trip_block_present == true
      - id: supplement_blocks
        type: supplement_block
        repeat: expr
        repeat-expr: header.supplement_block_count
      - id: reservation_blocks
        type: reservation_block
        repeat: expr
        repeat-expr: header.reservation_block_count
      - id: pass_blocks
        type: pass_block
        repeat: expr
        repeat-expr: header.pass_block_count

  mav_timestamp:
    doc: Number of seconds since 2017-01-01T00:00:00+01:00 (CET).
    seq:
      - id: seconds_since_2017
        type: u4
    instances:
      unix_timestamp:
        value: seconds_since_2017 + 1483225200
  header_flags:
    seq:
      - id: person_block_present
        type: b1
      - id: reserved
        type: b6
      - id: trip_block_present
        type: b1
  header:
    seq:
      - id: ticket_number
        type: str
        size: 18
        if: _root.version < 5
      - id: issuer
        type: u2
        doc: Numeric RICS code
        if: _root.version < 5
      - id: issuing_time
        type: mav_timestamp
      - id: price
        type: f4
      - id: flags
        type: header_flags
      - id: supplement_block_count
        type: u1
      - id: reservation_block_count
        type: u1
      - id: pass_block_count
        type: u1
      - id: reserved_2
        size: 3
      - id: unknown_1
        type: u4

  mav_birth_date:
    doc: Encoded as year * 10000 + month * 100 + day
    seq:
      - id: packed
        type: u4
    instances:
      year:
        value: packed / 10000
      month:
        value: (packed - year*10000)/100
      day:
        value: packed - year*10000 - month*100
  person_block:
    seq:
      - id: name
        type: str
        size: 45
      - id: birth_date
        type: mav_birth_date
      - id: id_card_number
        type: str
        size: 15

  station_id:
    doc: |
      7 digit UIC station code (version < 5) or numeric Hungarian station code (version >= 5),
      presumably https://www.wikidata.org/wiki/Property:P11451.
    seq:
      - id: station_id
        type: b24
  trip_block:
    seq:
      - id: ticket_name
        type: u4
        doc: Mapping of values to actual ticket types is still unknown.
      - id: departure_station
        type: station_id
      - id: destination_station
        type: station_id
      - id: via_stations
        type: station_id
        repeat: expr
        repeat-expr: 15
      - id: via_stations_return
        type: station_id
        repeat: expr
        repeat-expr: 15
      - id: class
        type: str
        size: 1
      - id: specimen
        type: u1
        doc: 0x1 for production tickets, 0x0 for specimens
      - id: departure_time
        type: mav_timestamp
      - id: validity_length
        type: b24
        doc: In minutes.
      - id: number_of_passengers
        type: u1
      - id: discount_name
        type: u4

  supplement_block:
    seq:
      - id: departure_station
        type: station_id
      - id: destination_station
        type: station_id
      - id: class
        type: str
        size: 1
      - id: ticket_name
        type: u4
      - id: valid_from
        type: mav_timestamp
      - id: validity_length
        type: b24
        doc: In minutes.
      - id: number_of_passengers
        type: u1
      - id: discount_name
        type: u4

  reservation_block:
    seq:
      - id: departure_station
        type: station_id
      - id: destination_station
        type: station_id
      - id: ticket_name
        type: u4
        doc: Mapping of values to actual ticket types still unknown.
      - id: departure_time
        type: mav_timestamp
      - id: operator
        type: u2
        doc: Numeric RICS code
      - id: train_number
        type: str
        size: '_root.version >= 6 ? 20 : 5'
      - id: unknown
        size: 1
      - id: coach_number
        type: str
        size: 3
      - id: seat_number1
        type: u2
      - id: seat_number2
        type: u2
      - id: reserved
        size: 28

  pass_block:
    seq:
      - id: pass_name
        type: u4
        doc: Mapping of values to actual ticket types still unknown.
      - id: discount_name
        type: u4
      - id: unknown
        type: u4
      - id: valid_from
        type: mav_timestamp
      - id: valid_until
        type: b24
        doc: In minutes.
      - id: number_of_passengers
        type: u1
