
--
-- The news applet for dotLRN
-- copyright 2001, OpenForce
-- distributed under GPL v2.0
--
--
-- ben,arjun@openforce.net
--
-- 10/05/2001
--


declare
	foo integer;
begin
	-- create the implementation
	foo := acs_sc_impl.new (
		'dotlrn_applet',
		'dotlrn_news',
		'dotlrn_news'
	);

	-- add all the hooks

	-- GetPrettyName
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_news',
	       'GetPrettyName',
	       'dotlrn_news::get_pretty_name',
	       'TCL'
	);

	-- AddApplet
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_news',
	       'AddApplet',
	       'dotlrn_news::add_applet',
	       'TCL'
	);

	-- RemoveApplet
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_news',
	       'RemoveApplet',
	       'dotlrn_news::remove_applet',
	       'TCL'
	);

	-- AddUser
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_news',
	       'AddUser',
	       'dotlrn_news::add_user',
	       'TCL'
	);

	-- RemoveUser
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_news',
	       'RemoveUser',
	       'dotlrn_news::remove_user',
	       'TCL'
	);

	-- Add the binding
	acs_sc_binding.new (
	    contract_name => 'dotlrn_applet',
	    impl_name => 'dotlrn_news'
	);
end;
/
show errors
