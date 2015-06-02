#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/helpers.sh

test_plugin_installation() {
	set_tmux_conf_helper <<- HERE
	set @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$PWD/tpm"
	HERE

	# opens tmux and test it with `expect`
	"$CURRENT_DIR"/expect_successful_plugin_download ||
		fail_helper "Tmux plugin installation fails"

	# check plugin dir exists after download
	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-example-plugin/" ||
		fail_helper "Plugin download fails"

	teardown_helper
}

test_multiple_plugins_installation() {
	set_tmux_conf_helper <<- HERE
	set @plugin "tmux-plugins/tmux-example-plugin"
	set   @plugin 'tmux-plugins/tmux-copycat'
	run-shell "$PWD/tpm"
	HERE

	# opens tmux and test it with `expect`
	"$CURRENT_DIR"/expect_successful_multiple_plugins_download ||
		fail_helper "Tmux multiple plugins installation fails"

	# check plugin dir exists after download
	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-example-plugin/" ||
		fail_helper "Plugin download fails (tmux-example-plugin)"

	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-copycat/" ||
		fail_helper "Plugin download fails (tmux-copycat)"

	teardown_helper
}

main() {
	test_plugin_installation
	test_multiple_plugins_installation
	exit_value_helper
}
main
