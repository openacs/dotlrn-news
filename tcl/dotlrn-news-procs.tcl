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
	community_id
    } {
	Add the news applet
    } {
	# Callback to get node_id from community
	# REVISIT this (ben)
	set node_id [site_node_id [ad_conn url]]

	# create the news package instance (all in one, I've mounted it)
	set package_key [package_key]
	set package_id [dotlrn::instantiate_and_mount $community_id $package_key]
	# set package_id [site_node_mount_application -return package_id $node_id $package_key $package_key $package_key]

	# return the package_id
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
	Add a user to a community
    } {

#	ad_return_complaint 1 "$community_id $user_id"
	# Get the page_id by callback
	set page_id [dotlrn_community::get_page_id $community_id $user_id]
	
	# Get the package_id by callback
	set package_id [dotlrn_community::get_applet_package_id $community_id dotlrn_news]

	# Allow user to see the news folders
	# nothing for now

	# Call the portal element to be added correctly


	# Make news DS available to this page
	news_portlet::make_self_available $page_id

	news_portlet::add_self_to_page $page_id $package_id
    }

    ad_proc -public remove_user {
	community_id
	user_id
    } {
	Remove a user from a community
    } {
	# Get the page_id
	set page_id [dotlrn_community::get_page_id $community_id $user_id]
	
	# Get the package_id by callback
	set package_id [dotlrn_community::get_package_id $community_id]

	# Remove the portal element
	news_portlet::remove_self_from_page $page_id $package_id

	# Buh Bye.
	news_portlet::make_self_unavailable $page_id

	# remove user permissions to see news folders
	# nothing to do here
    }
	
}
