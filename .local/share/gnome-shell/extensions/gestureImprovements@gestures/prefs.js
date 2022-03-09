/* exported init, buildPrefsWidget */

const Me = imports.misc.extensionUtils.getCurrentExtension();
const { getPrefsWidget } = Me.imports.common.prefs;
const ExtensionUtils = imports.misc.extensionUtils;
const ExtMe = ExtensionUtils.getCurrentExtension();
// eslint-disable-next-line @typescript-eslint/no-empty-function
function init() { }
function buildPrefsWidget() {
	const UIFilePath = ExtMe.dir.get_child('ui').get_path() + '/prefs.ui';
	const settings = ExtensionUtils.getSettings();
	return getPrefsWidget(settings, UIFilePath);
}
