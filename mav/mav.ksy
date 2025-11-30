meta:
  id: barcode_mav
  title: MÁV domestic ticket barcodes (outer layer)
  endian: be
  encoding: UTF-8
  license: CC0-1.0

doc: |
  Outer part of MÁV barcodes, apply mav_inner_vN.ksy to the compressed
  part of this.

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
    process: zlib
    size-eos: true
