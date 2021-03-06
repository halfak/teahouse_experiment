CREATE TABLE `th_retention_sample_preinvite_edits` (
  `rev_id` int(8) unsigned NOT NULL DEFAULT '0',
  `rev_page` int(8) unsigned NOT NULL DEFAULT '0',
  `rev_text_id` int(8) unsigned NOT NULL DEFAULT '0',
  `rev_comment` varbinary(255) DEFAULT NULL,
  `rev_user` int(5) unsigned NOT NULL DEFAULT '0',
  `rev_user_text` varbinary(255) NOT NULL DEFAULT '',
  `rev_timestamp` varbinary(14) NOT NULL DEFAULT '',
  `rev_minor_edit` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `rev_deleted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `rev_len` int(8) unsigned DEFAULT NULL,
  `rev_parent_id` int(8) unsigned DEFAULT NULL,
  `rev_sha1` varbinary(32) NOT NULL DEFAULT '',
  `rev_content_model` varbinary(32) DEFAULT NULL,
  `rev_content_format` varbinary(64) DEFAULT NULL,
  `user_registration` bigint(11) DEFAULT NULL,
  `sample_date` varbinary(255) DEFAULT NULL,
  `sample_group` varbinary(7) DEFAULT NULL,
  `page_namespace` int(11) NOT NULL DEFAULT '0',
  `page_title` varbinary(255) NOT NULL DEFAULT '',
  `page_restrictions` tinyblob NOT NULL,
  `page_counter` bigint(20) unsigned NOT NULL DEFAULT '0',
  `page_is_redirect` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `page_is_new` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `page_random` double unsigned NOT NULL DEFAULT '0',
  `page_touched` varbinary(14) NOT NULL DEFAULT '',
  `page_links_updated` varbinary(14) DEFAULT NULL,
  `page_latest` int(8) unsigned NOT NULL DEFAULT '0',
  `page_len` int(8) unsigned NOT NULL DEFAULT '0',
  `page_content_model` varbinary(32) DEFAULT NULL
) ENGINE=Aria DEFAULT CHARSET=binary PAGE_CHECKSUM=1
