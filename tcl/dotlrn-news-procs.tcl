#
#  Copyright (C) 2001, 2002 OpenForce, Inc.
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

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
    
    ad_proc -public applet_key {
    } {
        return the applet_key
    } {
        return "dotlrn_news"
    }

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
        dotlrn_applet::add_applet_to_dotlrn -applet_key [applet_key]
    }

    ad_proc -public remove_applet {
    } {
	One time destroy. 
    } {
        dotlrn_applet::remove_applet_from_dotlrn -applet_key [applet_key]
    }

    ad_proc -public add_applet_to_community {
	community_id
    } {
	Add the news applet to a specifc dotlrn community
    } {
	set portal_id [dotlrn_community::get_portal_id -community_id $community_id]

        if {[dotlrn_community::dummy_comm_p -community_id $community_id]} {
            news_portlet::add_self_to_page -portal_id $portal_id -package_id 0
            return
        }

	# create the news package instance (all in one, I've mounted it)
	set package_key [package_key]
	set package_id [dotlrn::instantiate_and_mount $community_id $package_key]

	news_portlet::add_self_to_page \
            -portal_id $portal_id \
            -package_id $package_id

	# set up the DS for the admin portal
        set admin_portal_id [dotlrn_community::get_admin_portal_id \
                                 -community_id $community_id
        ]

	news_admin_portlet::add_self_to_page \
            -portal_id $admin_portal_id \
            -package_id $package_id
        
	return $package_id
    }

    ad_proc -public remove_applet_from_community {
	community_id
    } {
	remove the applet from the community
    } {
        set package_id [dotlrn::get_community_applet_package_id \
            -community_id $community_id \
            -package_key [package_key]
        ]

        set admin_portal_id [dotlrn_community::get_admin_portal_id \
                                 -community_id $community_id
        ]
	
        set portal_id [dotlrn_community::get_portal_id \
                           -community_id $community_id
        ]

	news_admin_portlet::remove_self_from_page \
            -portal_id $admin_portal_id

	news_portlet::remove_self_from_page \
            -portal_id $portal_id \
            -package_id $package_id

        site_node_delete_package_instance \
            -node_id [dotlrn::get_community_applet_node_id \
                          -community_id $community_id \
                          -package_key [package_key]]
    }

    ad_proc -public add_user {
	user_id
    } {
	one time user-specifuc init
    } {
	return
    }

    ad_proc -public remove_user {
        user_id
    } {
    } {
    }

    ad_proc -public add_user_to_community {
	community_id
	user_id
    } {
	Add a user to a specifc dotlrn community
    } {
        set package_id [dotlrn_community::get_applet_package_id $community_id [applet_key]]
	set portal_id [dotlrn::get_workspace_portal_id $user_id]

        news_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id
    }

    ad_proc -public remove_user_from_community {
        community_id
        user_id
    } {
        Remove a user from a community
    } {
        set package_id [dotlrn_community::get_applet_package_id $community_id [applet_key]]
        set portal_id [dotlrn::get_workspace_portal_id $user_id]

        set args [ns_set create args]
        ns_set put $args user_id $user_id
        ns_set put $args community_id $community_id
        ns_set put $args package_id $package_id
        set list_args [list $portal_id $args]

        remove_portlet $portal_id $args
    }
	
    ad_proc -public add_portlet {
        portal_id
        args
    } {
        A helper proc to add the underlying portlet to the given portal. 
        
        @param portal_id
        @param args A list of key-value pairs (possibly user_id, community_id, and more)
    } {
        ns_log notice "** Error in [get_pretty_name]: 'add_portlet' not implemented!"
        ad_return_complaint 1  "Please notifiy the administrator of this error:
        ** Error in [get_pretty_name]: 'add_portlet' not implemented!"
    }


    ad_proc -public remove_portlet {
        portal_id
        args
    } {
        A helper proc to remove the underlying portlet from the given portal. 
        
        @param portal_id
        @param args A list of key-value pairs (possibly user_id, community_id, and more)
    } { 
        set user_id [ns_set get $args "user_id"]
        set community_id [ns_set get $args "community_id"]

        if {![empty_string_p $user_id]} {
            # the portal_id is a user's portal
            set news_package_id [ns_set get $args "news_package_id"]
        } elseif {![empty_string_p $community_id]} {
            # the portal_id is a community portal
            ad_return_complaint 1  "[applet_key] aks1 unimplimented"
        } else {
            # the portal_id is a portal template
            ad_return_complaint 1  "[applet_key] aks2 unimplimented"
        }

        news_portlet::remove_self_from_page \
            -portal_id $portal_id \
            -package_id $news_package_id
    }

    ad_proc -public clone {
        old_community_id
        new_community_id
    } {
        Clone this applet's content from the old community to the new one
    } {
        ns_log notice "** Error in [get_pretty_name] 'clone' not implemented!"
        ad_return_complaint 1  "Please notifiy the administrator of this error:
        ** Error in [get_pretty_name]: 'clone' not implemented!"
    }

}
