ad_library {

        Automated tests for the dotlrn-news package.

        @author Héctor Romojaro <hector.romojaro@gmail.com>
        @creation-date 2019-09-10

}

aa_register_case \
    -cats {api smoke production_safe} \
    -procs {
        dotlrn_news::package_key
        dotlrn_news::my_package_key
        dotlrn_news::applet_key
    } \
    dotlrn_news__keys {

        Simple test for the various dotlrn_news::..._key procs.

        @author Héctor Romojaro <hector.romojaro@gmail.com>
        @creation-date 2019-09-10
} {
    aa_equals "Package key" "[dotlrn_news::package_key]" "news"
    aa_equals "My Package key" "[dotlrn_news::my_package_key]" "dotlrn-news"
    aa_equals "Applet key" "[dotlrn_news::applet_key]" "dotlrn_news"
}


aa_register_case -procs {
        dotlrn_news::get_pretty_name
    } -cats {
        api
        production_safe
    } dotlrn_news__names {
        Test diverse name procs.
} {
    aa_equals "Pretty name" "[dotlrn_news::get_pretty_name]" "[_ dotlrn-news.pretty_name]"
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End: