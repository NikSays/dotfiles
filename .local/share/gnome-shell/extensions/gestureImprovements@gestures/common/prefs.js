/* exported getPrefsWidget */
const Gio = imports.gi.Gio;
const GObject = imports.gi.GObject;
const Gtk = imports.gi.Gtk;
const Me = imports.misc.extensionUtils.getCurrentExtension();
const { CanEnableMinimizeGesture } = Me.imports.common.utils.prefUtils;
/**
 * Bind value of setting to {@link Gtk.SpinButton}
 * @param key key of setting and id of {@link Gtk.SpinButton} object in builder
 */
function bind_int_value(key, settings, builder) {
	const button = builder.get_object(key);
	settings.bind(key, button, 'value', Gio.SettingsBindFlags.DEFAULT);
}
/**
 * Bind value of settings to {@link Gtk.Swich}
 * @param key key of setting and id of {@link Gtk.Switch} object in builder
 */
function bind_boolean_value(key, settings, builder, params) {
	var _a, _b;
	const button = builder.get_object(key);
	settings.bind(key, button, 'active', (_a = params === null || params === void 0 ? void 0 : params.flags) !== null && _a !== void 0 ? _a : Gio.SettingsBindFlags.DEFAULT);
	(_b = params === null || params === void 0 ? void 0 : params.sensitiveRowKeys) === null || _b === void 0 ? void 0 : _b.forEach(row_key => {
		const row = builder.get_object(row_key);
		button.bind_property('active', row, 'sensitive', GObject.BindingFlags.SYNC_CREATE);
	});
}
function bind_combo_box(key, settings, builder) {
	const comboBox = builder.get_object(key);
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	const enumKey = key;
	comboBox.set_active_id(settings.get_enum(enumKey).toString());
	comboBox.connect('changed', () => {
		settings.set_enum(enumKey, parseInt(comboBox.active_id));
	});
}
/**
 * Display value of `key` in log scale.
 * @param key key of setting and id of {@link Gtk.Scale} object in builder
 */
function display_in_log_scale(key, label_key, settings, builder) {
	const scale = builder.get_object(key);
	const label = builder.get_object(label_key);
	// display value in log scale
	scale.connect('value-changed', () => {
		const labelValue = Math.exp(scale.adjustment.value / Math.LOG2E).toFixed(2);
		label.set_text(labelValue);
		settings.set_double(key, parseFloat(labelValue));
	});
	const initialValue = Math.log2(settings.get_double(key));
	scale.set_value(initialValue);
}
/** Show button to enable minimize gesture, returns whether button was shown */
function showEnableMinimizeButton(key, row_key, settings, builder) {
	const row = builder.get_object(row_key);
	row.visible = settings.get_boolean(key) || CanEnableMinimizeGesture();
	if (row.visible)
		bind_boolean_value(key, settings, builder);
	return row.visible;
}
/**
 * Binds preference widgets and settings keys
 * @param settings setting object of extension
 * @param uiPath path of ui file
 * @returns Get preference widget of type {@link T}
 */
function getPrefsWidget(settings, uiPath) {
	const builder = new Gtk.Builder();
	builder.add_from_file(uiPath);
	display_in_log_scale('touchpad-speed-scale', 'touchpad-speed_scale_display-value', settings, builder);
	display_in_log_scale('touchpad-pinch-speed', 'touchpad-pinch-speed_display-value', settings, builder);
	bind_int_value('alttab-delay', settings, builder);
	bind_boolean_value('default-session-workspace', settings, builder, { flags: Gio.SettingsBindFlags.INVERT_BOOLEAN });
	bind_boolean_value('default-overview', settings, builder, { flags: Gio.SettingsBindFlags.INVERT_BOOLEAN });
	bind_boolean_value('follow-natural-scroll', settings, builder);
	bind_boolean_value('enable-alttab-gesture', settings, builder, { sensitiveRowKeys: ['alttab-delay_box-row'] });
	bind_boolean_value('enable-window-manipulation-gesture', settings, builder, { sensitiveRowKeys: ['allow-minimize-window_box-row'] });
	showEnableMinimizeButton('allow-minimize-window', 'allow-minimize-window_box-row', settings, builder);
	bind_combo_box('pinch-3-finger-gesture', settings, builder);
	bind_combo_box('pinch-4-finger-gesture', settings, builder);
	const main_prefs = builder.get_object('main_prefs');
	const header_bar = builder.get_object('header_bar');
	main_prefs.connect('realize', () => {
		const window = main_prefs.get_root();
		if (window && window instanceof Gtk.Window)
			window.set_titlebar(header_bar);
	});
	return main_prefs;
}
