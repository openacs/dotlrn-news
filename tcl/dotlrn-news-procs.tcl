# Procs for DOTLRN news Applet
# Copyright 2001 OpenForce, inc.
# Distributed under the GNU GPL v2
#
# Nov 2001
#

ad_library {
    
    Procs to set up the dotLRN news applet
    
    @author ben@openforce.net,arjun@openforce.net
    @creation-date 2001-11-11
    
}

namespace eval dotlrn_news {
    
    ad_proc -public package_key {
    } {
	get the package_key this applet deals with
    } {
	return "news"
    }

    ad_proc portal_element_key {
    } {
	return the portal element key
    } {
	return "news-portlet"
    }

    ad_proc -public get_pretty_name {
    } {
	returns the pretty name
    } {
	return "dotLRN News"
    }

    ad_proc -public add_applet {
    } {
	One time init - must be repeatable!
    } {
        dotlrn_community::add_applet_to_dotlrn -applet_key "dotlrn_news"
    }

    ad_proc -public add_applet_to_community {
	community_id
    } {
	Add the news applet to a specifc dotlrn community
    } {
	# Callback to get node_id from community
	# REVISIT this (ben)
	set node_id [site_node_id [ad_conn url]]

	# create the news package instance (all in one, I've mounted it)
	set package_key [package_key]
	set package_id [dotlrn::instantiate_and_mount $community_id $package_key]

	# portal template stuff
	set pt_id [dotlrn_community::get_portal_template_id $community_id]

	# set up the DS for the portal template
	news_portlet::make_self_available $pt_id
	news_portlet::add_self_to_page $pt_id $package_id

	return $package_id
    }

    ad_proc -public remove_applet {
	community_id
	package_id
    } {
	remove the applet from the community
    } {
	# Remove all instances of the news portlet! (this is some serious stuff!)

	# Dropping all messages, forums

	# Killing the package
    
    }

    ad_proc -public add_user {
	community_id
	user_id
    } {
	one time user-specifuc init
    } {
	return
    }

    ad_proc -public add_user_to_community {
	community_id
	user_id
    } {
	Add a user to a specifc dotlrn community
    } {

#	ad_return_complaint 1 "$community_id $user_id"
	# Get the portal_id by callback
	set portal_id [dotlrn_community::get_portal_id $community_id $user_id]
	
	# Get the package_id by callback
	set package_id [dotlrn_community::get_applet_package_id $community_id dotlrn_news]

	# Allow user to see the news folders
	# nothing for now

	# Make news DS available to this page
	news_portlet::make_self_available $portal_id

	news_portlet::add_self_to_page $portal_id $package_id

	# Now for the user workspace
	set workspace_portal_id [dotlrn::get_workspace_portal_id $user_id]

	# Add the portlet here
	if { $workspace_portal_id != "" } {
            news_portlet::add_self_to_page $workspace_portal_id $package_id
        }
    }

    ad_proc -public remove_user {
	community_id
	user_id
    } {
	Remove a user from a community
    } {
	# Get the portal_id
	set portal_id [dotlrn_community::get_portal_id $community_id $user_id]
	
	# Get the package_id by callback
	set package_id [dotlrn_community::get_package_id $community_id]

	# Remove the portal element
	news_portlet::remove_self_from_page $portal_id $package_id

	# Buh Bye.
	news_portlet::make_self_unavailable $portal_id

	# remove user permissions to see news folders
	# nothing to do here
    }
	
}
