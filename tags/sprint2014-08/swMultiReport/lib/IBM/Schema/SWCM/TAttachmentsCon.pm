package IBM::Schema::SWCM::TAttachmentsCon;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_attachments_con");
__PACKAGE__->add_columns(
  "attach_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "contract_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("attach_id", "contract_id");
__PACKAGE__->belongs_to(
  "attach",
  "IBM::Schema::SWCM::TAttachments",
  { attach_id => "attach_id" },
);
__PACKAGE__->belongs_to(
  "contract",
  "IBM::Schema::SWCM::TContract",
  { contract_id => "contract_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IxSQPtvRby1xgegzOc031w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
