use utf8;
package Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("user");
__PACKAGE__->add_columns(
  "n",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "full_name",
  { data_type => "text", is_nullable => 1 },
  "email",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("n");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-09-11 12:35:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qfHQUd40NsgpiGVZbsjOiQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
