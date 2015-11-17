import os.path

from nose.tools import eq_

from .. import teahouse_links

pwd = os.path.dirname(os.path.realpath(__file__))
OMOYOYO = open(os.path.join(pwd, "omoyoyo.txt")).read()
J34JHON = open(os.path.join(pwd, "j34jhon.txt")).read()


def test_teahouse_links():
    not_relevant = "[[Foo:Bar|Derp]]"
    eq_(list(teahouse_links.extract(not_relevant)), [])

    relevant = "[[WP:TH]]"
    eq_(list(teahouse_links.extract(relevant)),
        ["wp:th"])

    relevant = "[[File:Foo|link=WP:TH]]"
    eq_(list(teahouse_links.extract(relevant)),
        ["wp:th"])

    relevant = "[[Wikipedia:THQ]]"
    eq_(list(teahouse_links.extract(relevant)),
        ["wikipedia:thq"])

    relevant = "[[WP:TH/Q]]"
    eq_(list(teahouse_links.extract(relevant)),
        ["wp:th/q"])

    relevant = "[[WP:Teahouse/Questions]]"
    eq_(list(teahouse_links.extract(relevant)),
        ["wp:teahouse/questions"])

def test_omoyoyo_talk_page():
    eq_(list(teahouse_links.extract(OMOYOYO)),
        ['wp:teahouse'])


def test_j34jhon_talk_page():
    eq_(list(teahouse_links.extract(J34JHON)),
        ['wp:teahouse', 'wp:teahouse', 'wp:teahouse/hosts', 'wp:teahouse'])
