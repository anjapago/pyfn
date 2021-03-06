"""Behavior tests for marshallers.bios."""

import pyfn.marshalling.marshallers.bios as bios

from pyfn.models.target import Target


def test_get_token_index_3uples():
    text = 'This is a test'
    token_index_3uples = bios._get_token_index_3uples(text)
    assert len(token_index_3uples) == 4
    assert token_index_3uples[0] == ('This', 0, 3)
    assert token_index_3uples[3] == ('test', 10, 13)


def test_get_valence_units_by_indexes():
    vus_by_indexes = {(0,0): [0], (14,19): [1,2], (2,7): [3,4,5]}
    assert len(bios._get_valence_units_by_indexes(vus_by_indexes, 17, 20)) == 2
    assert len(bios._get_valence_units_by_indexes(vus_by_indexes, 0, 1)) == 1
    assert len(bios._get_valence_units_by_indexes(vus_by_indexes, 3, 9)) == 3
    assert len(bios._get_valence_units_by_indexes(vus_by_indexes, 11, 21)) == 2
    assert len(bios._get_valence_units_by_indexes(vus_by_indexes, 11, 15)) == 2
    assert len(bios._get_valence_units_by_indexes(vus_by_indexes, 3, 4)) == 3


def test_get_lexunit():
    target = Target(lexunit='lu', indexes=[(5,8), (15,19)])
    assert bios._get_lexunit(1, 4, target) == '_'
    assert bios._get_lexunit(6, 7, target) == 'lu'
    assert bios._get_lexunit(13, 16, target) == 'lu'
    assert bios._get_lexunit(8, 9, target) == 'lu'
    assert bios._get_lexunit(9, 14, target) == '_'
    assert bios._get_lexunit(13, 21, target) == 'lu'
    assert bios._get_lexunit(17, 22, target) == 'lu'
    assert bios._get_lexunit(16, 18, target) == 'lu'
