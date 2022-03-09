/* exported init */
const GLib = imports.gi.GLib;

const Me = imports.misc.extensionUtils.getCurrentExtension();
const { PinchGestureType } = Me.imports.common.settings;
const Constants = Me.imports.constants;
const { AltTabConstants, ExtSettings, TouchpadConstants } = Me.imports.constants;
const { AltTabGestureExtension } = Me.imports.src.altTab;
const { GestureExtension } = Me.imports.src.gestures;
const { OverviewRoundTripGestureExtension } = Me.imports.src.overviewRoundTrip;
const { ShowDesktopExtension } = Me.imports.src.pinchGestures.showDesktop;
const { SnapWindowExtension } = Me.imports.src.snapWindow;
const DBusUtils = Me.imports.src.utils.dbus;
const ExtensionUtils = imports.misc.extensionUtils;
class Extension {
	constructor() {
		this._settingChangedId = 0;
		this._reloadWaitId = 0;
		this._extensions = [];
		this._addReloadDelayFor = [
			'touchpad-speed-scale',
			'alttab-delay',
			'touchpad-pinch-speed',
		];
	}
	enable() {
		this.settings = ExtensionUtils.getSettings();
		this._settingChangedId = this.settings.connect('changed', this.reload.bind(this));
		this._enable();
	}
	disable() {
		if (this.settings) {
			this.settings.disconnect(this._settingChangedId);
		}
		if (this._reloadWaitId !== 0) {
			GLib.source_remove(this._reloadWaitId);
			this._reloadWaitId = 0;
		}
		this._disable();
		DBusUtils.drop_proxy();
	}
	reload(_settings, key) {
		if (this._reloadWaitId !== 0) {
			GLib.source_remove(this._reloadWaitId);
			this._reloadWaitId = 0;
		}
		this._reloadWaitId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, (this._addReloadDelayFor.includes(key) ? Constants.RELOAD_DELAY : 0), () => {
			this._disable();
			this._enable();
			this._reloadWaitId = 0;
			return GLib.SOURCE_REMOVE;
		});
	}
	_enable() {
		this._initializeSettings();
		this._extensions = [];
		if (this.settings === undefined)
			return;
		if (this.settings.get_boolean('enable-alttab-gesture'))
			this._extensions.push(new AltTabGestureExtension());
		this._extensions.push(new OverviewRoundTripGestureExtension(), new GestureExtension());
		if (this.settings.get_boolean('enable-window-manipulation-gesture'))
			this._extensions.push(new SnapWindowExtension());
		// pinch to show desktop
		const showDesktopFingers = [
			this.settings.get_enum('pinch-3-finger-gesture') === PinchGestureType.SHOW_DESKTOP ? 3 : undefined,
			this.settings.get_enum('pinch-4-finger-gesture') === PinchGestureType.SHOW_DESKTOP ? 4 : undefined,
		].filter((f) => typeof f === 'number');
		if (showDesktopFingers.length)
			this._extensions.push(new ShowDesktopExtension(showDesktopFingers));
		this._extensions.forEach(extension => extension.apply());
	}
	_disable() {
		DBusUtils.unsubscribeAll();
		this._extensions.reverse().forEach(extension => extension.destroy());
		this._extensions = [];
	}
	_initializeSettings() {
		if (this.settings) {
			ExtSettings.DEFAULT_SESSION_WORKSPACE_GESTURE = this.settings.get_boolean('default-session-workspace');
			ExtSettings.DEFAULT_OVERVIEW_GESTURE = this.settings.get_boolean('default-overview');
			ExtSettings.ALLOW_MINIMIZE_WINDOW = this.settings.get_boolean('allow-minimize-window');
			ExtSettings.FOLLOW_NATURAL_SCROLL = this.settings.get_boolean('follow-natural-scroll');
			TouchpadConstants.SWIPE_MULTIPLIER = Constants.TouchpadConstants.DEFAULT_SWIPE_MULTIPLIER * this.settings.get_double('touchpad-speed-scale');
			TouchpadConstants.PINCH_MULTIPLIER = Constants.TouchpadConstants.DEFAULT_PINCH_MULTIPLIER * this.settings.get_double('touchpad-pinch-speed');
			AltTabConstants.DELAY_DURATION = this.settings.get_int('alttab-delay');
		}
	}
}
function init() {
	return new Extension();
}