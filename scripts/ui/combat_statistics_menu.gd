extends Control
## One cached continuous journal. Menus observe facts; playback is requested from the arena.
signal playback_requested
const StatsList=preload("res://scripts/ui/combat_statistics_list.gd")
const PauseIcon=preload("res://assets/ui/journal_pause.svg")
const PlayIcon=preload("res://assets/ui/journal_play.svg")
var report:RefCounted
var stats_panel:PanelContainer
var journal_panel:PanelContainer
var hero_scroll:ScrollContainer
var enemy_scroll:ScrollContainer
var journal_scroll:ScrollContainer
var hero_list:Control
var enemy_list:Control
var console:RichTextLabel
var playback:Button
var direct:Button
var journal_title:Label
var stats_title:Label
var journal_mode:bool=false
var follow_live:bool=true
var playback_paused:bool=false
var _blocked:bool=false
var _can_play:bool=true
var _age:float=0
var _revision:int=-1
var _log_revision:int=-1
var _shown_first:int=-1
var _shown_last:int=-1
var _follow_pending:bool=false
var _scroll_token:int=0

func _ready() -> void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	stats_panel=_panel();add_child(stats_panel)
	var column:=VBoxContainer.new();column.add_theme_constant_override("separation",6);stats_panel.add_child(column)
	stats_title=_title(column,"Statistiques")
	var groups:=HBoxContainer.new();groups.add_theme_constant_override("separation",12);groups.size_flags_vertical=Control.SIZE_EXPAND_FILL;column.add_child(groups)
	var heroes:=_group(groups,"Héros");var enemies:=_group(groups,"Ennemis")
	hero_scroll=_scroll(heroes);enemy_scroll=_scroll(enemies)
	hero_list=_list(hero_scroll);enemy_list=_list(enemy_scroll)
	journal_panel=_panel();add_child(journal_panel)
	var journal_column:=VBoxContainer.new();journal_column.add_theme_constant_override("separation",6);journal_panel.add_child(journal_column)
	journal_title=_title(journal_column,"Journal de combat")
	journal_scroll=_scroll(journal_column)
	journal_scroll.get_v_scroll_bar().value_changed.connect(_journal_scrolled)
	console=RichTextLabel.new();console.bbcode_enabled=false;console.fit_content=true;console.scroll_active=false
	console.size_flags_horizontal=Control.SIZE_EXPAND_FILL;console.mouse_filter=Control.MOUSE_FILTER_IGNORE
	console.add_theme_font_size_override("normal_font_size",12);journal_scroll.add_child(console)
	var navigation:=HBoxContainer.new();navigation.add_theme_constant_override("separation",8);journal_column.add_child(navigation)
	playback=_button(navigation,"","Mettre le combat en pause",func():playback_requested.emit())
	playback.custom_minimum_size=Vector2(36,36);playback.icon_alignment=HORIZONTAL_ALIGNMENT_CENTER;playback.icon=PauseIcon
	direct=_button(navigation,"Direct","Revenir aux dernières actions",_direct)
	resized.connect(_layout);_layout();hide()

func _panel() -> PanelContainer:
	var panel:=PanelContainer.new()
	var style:=get_theme_stylebox("normal","Button").duplicate() as StyleBoxFlat
	style.bg_color.a=.72;style.border_color=Color("a68349");style.set_corner_radius_all(8)
	panel.add_theme_stylebox_override("panel",style);return panel
func _title(parent:Node,text:String) -> Label:
	var label:=Label.new();label.text=text;label.clip_text=true
	label.add_theme_font_size_override("font_size",18);label.add_theme_color_override("font_color",Color("ffd16a"));parent.add_child(label);return label
func _scroll(parent:Node) -> ScrollContainer:
	var scroll:=ScrollContainer.new();scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_vertical=Control.SIZE_EXPAND_FILL;scroll.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	parent.add_child(scroll);return scroll
func _button(parent:Node,text:String,hint:String,callback:Callable) -> Button:
	var button:=Button.new();button.text=text;button.tooltip_text=hint;button.custom_minimum_size=Vector2(28,32)
	button.add_theme_font_size_override("font_size",12)
	for state in ["normal","hover","pressed","focus","disabled"]:
		var paint:=get_theme_stylebox(state,"Button").duplicate() as StyleBoxFlat;paint.set_content_margin_all(5);button.add_theme_stylebox_override(state,paint)
	button.pressed.connect(callback);parent.add_child(button);return button
func _group(parent:Node,text:String) -> VBoxContainer:
	var group:=VBoxContainer.new();group.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	group.size_flags_stretch_ratio=1;parent.add_child(group)
	var heading:=_title(group,text);heading.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;heading.add_theme_font_size_override("font_size",16)
	return group
func _list(scroll:ScrollContainer) -> Control:
	var list:=StatsList.new();list.show_headings=false;list.scroller=scroll;scroll.add_child(list)
	scroll.get_v_scroll_bar().value_changed.connect(func(_value:float):list.queue_redraw())
	return list
func open(values:RefCounted,journal:bool=false) -> void:
	report=values;_revision=-1;_log_revision=-1;journal_mode=journal;follow_live=true;_shown_first=-1;_shown_last=-1
	show();_layout();refresh(true)
func handle_back() -> void:hide()
func _layout() -> void:
	if stats_panel==null:return
	stats_panel.visible=not journal_mode;stats_panel.position=Vector2.ZERO;stats_panel.size=size
	journal_panel.visible=journal_mode;journal_panel.position=Vector2.ZERO;journal_panel.size=size
func _process(delta:float) -> void:
	if not visible or report==null:return
	_age+=delta
	if _age>=.25:_age=0;refresh()
func refresh(force:bool=false) -> void:
	if report==null:return
	if force or _revision!=report.revision:
		_revision=report.revision
		var rows:Array[Dictionary]=report.ordered()
		hero_list.mvp=report.mvp_id();hero_list.set_rows(rows.filter(func(row):return row.team==0),report.peaks)
		enemy_list.set_rows(rows.filter(func(row):return row.team!=0),report.peaks)
	if journal_mode and (force or _log_revision!=report.log_revision):
		_log_revision=report.log_revision;_sync_console()

func _sync_console() -> void:
	var lines:Array=report.recent
	var wanted:int=journal_scroll.scroll_vertical
	var removed_height:float=0
	_follow_pending=true
	if lines.is_empty():console.clear();_shown_first=-1;_shown_last=-1
	else:
		var first:int=int(lines[0].id)
		if _shown_first<0 or _shown_last<first-1 or _shown_last>=report.entries:
			console.clear();_shown_first=first;_shown_last=first-1
		else:
			var removed:int=maxi(0,first-_shown_first)
			if removed>0:
				removed_height=console.get_paragraph_offset(mini(removed,console.get_paragraph_count()-1))
				for index in range(removed):console.remove_paragraph(0,true)
				console.invalidate_paragraph(0);_shown_first=first
		for entry in lines:
			if int(entry.id)<=_shown_last:continue
			var stamp:String=timestamp(float(entry.time))
			console.push_color(Color("8b9bb5"));console.add_text(stamp+"  ");console.pop()
			console.push_color(Color(entry.color));console.add_text(str(entry.text)+"\n");console.pop()
			_shown_last=int(entry.id)
	_scroll_token+=1;call_deferred("_settle_scroll",_scroll_token,-1 if follow_live else maxi(0,wanted-roundi(removed_height)))
	direct.disabled=_blocked or follow_live
func _settle_scroll(token:int,wanted:int) -> void:
	await get_tree().process_frame
	if token!=_scroll_token:return
	if visible and journal_mode:
		journal_scroll.scroll_vertical=int(journal_scroll.get_v_scroll_bar().max_value) if wanted<0 and follow_live else maxi(0,wanted)
	await get_tree().process_frame
	if token==_scroll_token:_follow_pending=false
func _direct() -> void:
	follow_live=true;refresh(true)
func scrollers() -> Array[ScrollContainer]:
	var result:Array[ScrollContainer]=[]
	if visible:
		if journal_mode:result.append(journal_scroll)
		else:result.assign([hero_scroll,enemy_scroll])
	return result
func set_blocked(blocked:bool) -> void:
	_blocked=blocked;direct.disabled=blocked or follow_live
	playback.disabled=blocked or not _can_play
func sync_playback(paused:bool,can_play:bool) -> void:
	playback_paused=paused;_can_play=can_play
	playback.icon=PlayIcon if paused else PauseIcon
	playback.tooltip_text="Reprendre le combat" if paused else "Mettre le combat en pause"
	playback.disabled=_blocked or not can_play
func _journal_scrolled(value:float) -> void:
	if _follow_pending or not visible or not journal_mode or not follow_live:return
	var bar:VScrollBar=journal_scroll.get_v_scroll_bar()
	if value<bar.max_value-bar.page-8:follow_live=false;direct.disabled=_blocked

static func timestamp(time:float) -> String:
	var millis:int=maxi(0,roundi(time*1000))
	return "%02d:%02d.%03d"%[floori(millis/60000.0),floori(millis/1000.0)%60,millis%1000]
