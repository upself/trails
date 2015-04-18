package Common::MetaRule;

use strict;


my $EVENT_RULE_CODE_INDEX                 = 0;#For example, "ERC001"
my $TRIGGERED_EVENT_GROUP_NAME_INDEX	  = 1;#For example, "TRAILS_BRAVO_CORE_SCRIPTS"
my $TRIGGERED_EVENT_NAME_INDEX			  = 2;#For example, "CONTINUOUS_RUN_SCRIPTS"
my $PARAMETER_1_INDEX					  = 3;#For example, "TAP3"
my $PARAMETER_2_INDEX					  = 4;#For example, "reconEngine.pl'softwareToBravo.pl'ipAddressToBravo.pl"
my $PARAMETER_3_INDEX					  = 5;#For example, "TAP"
my $PARAMETER_4_INDEX					  = 6;#For example, "doranaToSwasset.pl'hdiskToStaging.pl'ipAddressToStaging.pl"
my $PARAMETER_5_INDEX					  = 7;#For example, "N/A"
my $PARAMETER_6_INDEX					  = 8;#For example, "N/A"
my $PARAMETER_7_INDEX					  = 9;#For example, "N/A"
my $PARAMETER_8_INDEX					  = 10;#For example, "N/A"
my $PARAMETER_9_INDEX					  = 11;#For example, "N/A"
my $PARAMETER_10_INDEX					  = 12;#For example, "N/A"
my $EVENT_RULE_TITLE                      = 13;#For example, "Loader Running Status on @1 Server"
my $EVENT_RULE_MESSAGE                    = 14;#For example, "Loader @2 is currently not running."
my $EVENT_RULE_HANDLING_INSTRUCTION_CODE  = 15;#For example, "E-TBS-CRS-001"
my $EVENT_RULE_TRIGGER_FREQUENCY          = 16;#For example, 1(Unit:Hour)


###Object constructor.
sub new {
	my ( $class, $rules ) = @_;
	my $self = {
		_rules => $rules
	};
	
	bless $self, $class;

	###Call validation
	$self->parse;

	return $self;
}

sub parse(){
 my $self = shift;
 
 my $metaRule  = $self->rules;
 
  $self->metaRuleCode(trim($metaRule->[$EVENT_RULE_CODE_INDEX]));
  $self->metaRuleTriggerEventGroup(trim($metaRule->[$TRIGGERED_EVENT_GROUP_NAME_INDEX]));
  $self->metaRuleTriggerEventName(trim($metaRule->[$TRIGGERED_EVENT_NAME_INDEX]));
  $self->metaRuleParameter1(trim($metaRule->[$PARAMETER_1_INDEX]));
  $self->metaRuleParameter2(trim($metaRule->[$PARAMETER_2_INDEX]));
  $self->metaRuleParameter3(trim($metaRule->[$PARAMETER_3_INDEX]));
  $self->metaRuleParameter4(trim($metaRule->[$PARAMETER_4_INDEX]));
  $self->metaRuleParameter5(trim($metaRule->[$PARAMETER_5_INDEX]));
  $self->metaRuleParameter6(trim($metaRule->[$PARAMETER_6_INDEX]));
  $self->metaRuleParameter7(trim($metaRule->[$PARAMETER_7_INDEX]));
  $self->metaRuleParameter8(trim($metaRule->[$PARAMETER_8_INDEX]));
  $self->metaRuleParameter9(trim($metaRule->[$PARAMETER_9_INDEX]));
  $self->metaRuleParameter10(trim($metaRule->[$PARAMETER_10_INDEX]));
  $self->metaRuleTitle(trim($metaRule->[$EVENT_RULE_TITLE]));
  $self->metaRuleMessage(trim($metaRule->[$EVENT_RULE_MESSAGE]));
  $self->metaRuleHandlingInstrcutionCode(trim($metaRule->[$EVENT_RULE_HANDLING_INSTRUCTION_CODE]));
  $self->metaRuleTriggerFrequency(trim($metaRule->[$EVENT_RULE_TRIGGER_FREQUENCY]));
}


sub metaRuleCode {
	my ( $self, $value ) = @_;
	$self->{_metaRuleCode} = $value if defined($value);
	return ( $self->{_metaRuleCode} );
}

sub metaRuleTriggerEventGroup {
	my ( $self, $value ) = @_;
	$self->{_metaRuleTriggerEventGroup} = $value if defined($value);
	return ( $self->{_metaRuleTriggerEventGroup} );
}

sub metaRuleTriggerEventName {
	my ( $self, $value ) = @_;
	$self->{_metaRuleTriggerEventName} = $value if defined($value);
	return ( $self->{_metaRuleTriggerEventName} );
}

sub metaRuleParameter1 {
	my ( $self, $value ) = @_;
	$self->{_metaRuleParameter1} = $value if defined($value);
	return ( $self->{_metaRuleParameter1} );
}

sub metaRuleParameter2 {
	my ( $self, $value ) = @_;
	$self->{_metaRuleParameter2} = $value if defined($value);
	return ( $self->{_metaRuleParameter2} );
}


sub metaRuleParameter3 {
	my ( $self, $value ) = @_;
	$self->{_metaRuleParameter3} = $value if defined($value);
	return ( $self->{_metaRuleParameter3} );
}

sub metaRuleParameter4 {
	my ( $self, $value ) = @_;
	$self->{_metaRuleParameter4} = $value if defined($value);
	return ( $self->{_metaRuleParameter4} );
}

sub metaRuleParameter5 {
	my ( $self, $value ) = @_;
	$self->{_metaRuleParameter5} = $value if defined($value);
	return ( $self->{_metaRuleParameter5} );
}

sub metaRuleParameter6 {
	my ( $self, $value ) = @_;
	$self->{_metaRuleParameter6} = $value if defined($value);
	return ( $self->{_metaRuleParameter6} );
}

sub metaRuleParameter7 {
	my ( $self, $value ) = @_;
	$self->{_metaRuleParameter7} = $value if defined($value);
	return ( $self->{_metaRuleParameter7} );
}

sub metaRuleParameter8 {
	my ( $self, $value ) = @_;
	$self->{_metaRuleParameter8} = $value if defined($value);
	return ( $self->{_metaRuleParameter8} );
}

sub metaRuleParameter9 {
	my ( $self, $value ) = @_;
	$self->{_metaRuleParameter9} = $value if defined($value);
	return ( $self->{_metaRuleParameter9} );
}

sub metaRuleParameter10 {
	my ( $self, $value ) = @_;
	$self->{_metaRuleParameter10} = $value if defined($value);
	return ( $self->{_metaRuleParameter10} );
}

sub metaRuleTitle {
	my ( $self, $value ) = @_;
	$self->{_metaRuleTitle} = $value if defined($value);
	return ( $self->{_metaRuleTitle} );
}

sub metaRuleMessage {
	my ( $self, $value ) = @_;
	$self->{_metaRuleMessage} = $value if defined($value);
	return ( $self->{_metaRuleMessage} );
}

sub metaRuleHandlingInstrcutionCode {
	my ( $self, $value ) = @_;
	$self->{_metaRuleHandlingInstrcutionCode} = $value if defined($value);
	return ( $self->{_metaRuleHandlingInstrcutionCode} );
}

sub metaRuleTriggerFrequency {
	my ( $self, $value ) = @_;
	$self->{_metaRuleTriggerFrequency} = $value if defined($value);
	return ( $self->{_metaRuleTriggerFrequency} );
}

1;