import os.path

from nose.tools import eq_

from .. import subst_templates

pwd = os.path.dirname(os.path.realpath(__file__))
OMOYOYO = open(os.path.join(pwd, "omoyoyo.txt")).read()
J34JHON = open(os.path.join(pwd, "j34jhon.txt")).read()


def test_subst_templates():
    comment = "<!-- this is just a comment: yup -->"
    eq_(list(subst_templates.extract(comment)), [])

    template = "<!-- Template:foo -->"
    eq_(list(subst_templates.extract(template)),
        ["template:foo"])

    template = "<!-- Template:uw-vandalism1 -->"
    eq_(list(subst_templates.extract(template)),
        ["template:uw-vandalism1"])

    template = "<!-- Template:Foo_bar -->"
    eq_(list(subst_templates.extract(template)),
        ["template:foo bar"])

    template = "<!-- Wikipedia:Foo_bar -->"
    eq_(list(subst_templates.extract(template)),
        ["wikipedia:foo bar"])

    template = "<!-- WP:Foo_bar -->"
    eq_(list(subst_templates.extract(template)),
        ["wp:foo bar"])


def test_omoyoyo_talk_page():
    eq_(list(subst_templates.extract(OMOYOYO)),
        ['template:welcome',
         'template:uw-cluebotwarning1',
         'template:uw-vandalism1',
         'template:uw-speedy1',
         'template:db-notability-notice',
         'template:db-csd-notice-custom',
         'template:uw-speedy2',
         'template:uw-speedy3',
         'template:uw-speedy4',
         'template:db-repost-notice',
         'template:db-csd-notice-custom',
         'template:uw-speedy4',
         'template:db-repost-notice',
         'template:db-csd-notice-custom',
         'template:uw-blockindef'])


def test_j34jhon_talk_page():
    eq_(list(subst_templates.extract(J34JHON)),
        ['template:welcomeg',
         'template:uw-spam0',
         'template:teahouse hostbot invitation'])
