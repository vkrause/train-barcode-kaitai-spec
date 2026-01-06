meta:
  id: barcode_sncf_ter
  title: SNCF TER ticket barcode
  encoding: UTF-8
  license: CC0-1.0

doc: |
  Barcode used for regional trains in some areas of France.

seq:
  - id: magic
    contents: [0x32, 0x32, 0x30, 0x30]
  - id: signature
    size: 256
  - id: unknown_1
    contents: [0x30, 0x30, 0x54]
  - id: maybe_version
    type: str
    size: 1
  - id: uic_issuer_code
    type: str
    size: 4
  - id: ticket_number
    type: str
    size: 9
  - id: departure_station_code
    type: str
    size: 5
    doc: "can be empty for zone passes"
  - id: arrival_station_code
    type: str
    size: 5
    doc: "can be empty for zone passes"
  - id: via_station_code
    type: str
    size: 5
    doc: "optional, filled with 0x20 when not used"
  - id: zone_description
    type: str
    size: 50
    doc: "unused space filled with 0x20"
  - id: ticket_type
    type: str
    size: 1
    doc: "'S' for regular tickets, 'A' for multi-use passes"
  - id: travel_date
    type: str
    size: 8
    doc: "Format: ddMMyyyy"
  - id: class
    type: str
    size: 1
  - id: tariff_code
    type: str
    size: 4
  - id: ticket_name
    type: str
    size: 20
    doc: "unused space filled with 0x20"
  - id: traveler_family_name
    type: str
    size: 19
    doc: "left-aligned and blank (0x20) padded"
  - id: traveler_given_name
    type: str
    size: 19
    doc: "left-aligned and blank (0x20) padded"
  - id: traveler_birth_date
    type: str
    size: 8
    doc: "Format: ddMMyyyy"
  - id: traveler_type_1
    type: str
    size: 10
    doc: "e.g. 'ADULTE' or 'ENFANTE'"
  - id: traveler_type_amount_1
    type: str
    size: 2
    doc: "left-padded with '0'"
  - id: traveler_type_2
    type: str
    size: 10
    doc: "e.g. 'ADULTE' or 'ENFANTE', can be empty"
  - id: traveler_type_amount_2
    type: str
    size: 2
    doc: "left-padded with '0'"
  - id: valid_from
    type: str
    size: 8
    doc: "Format: ddMMyyyy"
  - id: valid_until
    type: str
    size: 8
    doc: "Format: ddMMyyyy"
  - id: unknown_2
    contents: [0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30]
  - id: issuing_time
    type: str
    size: 12
    doc: "Format: ddMMyyyyHHmm"
  - id: price
    type: str
    size: 10
    doc: "In Euro-cent, left-padded with '0'"
  - id: free_text
    type: str
    size: 190
    doc: "empty space filled with 0x20"
