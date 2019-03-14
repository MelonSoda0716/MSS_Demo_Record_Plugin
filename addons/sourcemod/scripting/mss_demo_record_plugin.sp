#include<sourcemod>
#include<cstrike>
#include<sdktools>

public Plugin:myinfo =
{
	name = "MSS Demo Record Plugin",
	author = "MelonSoda",
	description = "MelonSoda CS:GO Server Demo Record Plugin",
	version = "1.0.0",
	url = "https://www.melonsoda.tokyo/"
};

/**********************************
* Data Type
**********************************/
Handle cvar_tv_enable;
Handle cvar_tv_autorecord;

Handle cvar_mss_demo_native_plugin;
Handle cvar_mss_demo_name;
Handle cvar_mss_damo_directory;
Handle cvar_mss_demo_record_start;

new String:demo_name_formated[256];
new String:demo_directory_formated[256];
new String:full_path[512];
bool in_game = false;

/**********************************
* OnPluginStart
* プラグインが読み込まれたときに実行
**********************************/
public OnPluginStart(){

	RegConsoleCmd("say" , Command_Say);

	cvar_tv_enable               = FindConVar("tv_enable");
	cvar_tv_autorecord           = FindConVar("tv_autorecord");

	cvar_mss_demo_native_plugin  =  CreateConVar("mss_demo_native_plugin"     ,             "1"                , "1 = MSS Match Plugin Only.");
	cvar_mss_demo_name           =  CreateConVar("mss_demo_name"              , "auto-%Y%m%d-%H%M-<*MAPNAME*>" , "Demo name format (FormatTime).");
	cvar_mss_damo_directory      =  CreateConVar("mss_damo_directory"         , "demo_record/%Y-%m/%Y-%m-%d"   , "Demo directory format (FormatTime).");
	cvar_mss_demo_record_start   =  CreateConVar("mss_demo_record_start_time" ,            "5.0"               , "Record start time.");

	/* Cvarを強制的に変更する */
	HookConVarChange(cvar_tv_enable     , ForceCvarChange_cvar_tv_enable);
	HookConVarChange(cvar_tv_autorecord , ForceCvarChange_cvar_tv_autorecord);

	ServerCommand("exec mss_demo_record_plugin.cfg");

}

public ForceCvarChange_cvar_tv_enable(Handle:cvar, const String:oldVal[], const String:newVal[]){

	/* tv_enable "1" */
    SetConVarInt(cvar, 1);
}

public ForceCvarChange_cvar_tv_autorecord(Handle:cvar, const String:oldVal[], const String:newVal[]){

	/* tv_autorecord "0" */
    SetConVarInt(cvar, 0);
}

/**********************************
* OnMapStart
* マップが読み込まれたときに実行
**********************************/
public OnMapStart(){
	
	in_game = false;
	ServerCommand("exec mss_demo_record_plugin.cfg");

	/* ネイティブプラグインを使用していない場合はマップ開始時にDEMO録画開始 */
	if( GetConVarInt(cvar_mss_demo_native_plugin) == 0 ){
		/* mss_demo_record_start_timeの後DEMO録画開始 */
		CreateTimer(GetConVarFloat(cvar_mss_demo_record_start), DemoRecordStart);
	}

}

public Action:DemoRecordStart(Handle:timer){

	decl String:map[128];
	decl String:demo_name[128];
	decl String:demo_directory[128];

	/* 現在のマップ名を取得 */
	GetCurrentMap(map, sizeof(map));
	/* DEMOの名前を取得 */
	GetConVarString(cvar_mss_demo_name, demo_name, sizeof(demo_name));
	/* DEMOのディレクトリを取得 */
	GetConVarString(cvar_mss_damo_directory, demo_directory, sizeof(demo_directory));
	/* DEMO名の日付を取得 */
	FormatTime(demo_name_formated, sizeof(demo_name_formated), demo_name);
	/* ディレクトリ名の日付を取得 */
	FormatTime(demo_directory_formated, sizeof(demo_directory_formated), demo_directory);
	/* マップ名を置換 */
	ReplaceString(demo_name_formated, sizeof(demo_name_formated), "<*MAPNAME*>", map);
	/* スラッシュをアンダーバに置換 */
	ReplaceString(demo_name_formated, sizeof(demo_name_formated), "/", "_");
	/* ディレクトリが存在するかを確認 */
	if(!DirExists(demo_directory_formated)){
		/* DEMO保存先のディレクトリを作成 */
		CreateDirectory_EX();
	}
	/* Full Path */
	Format(full_path, sizeof(full_path), "%s/%s", demo_directory_formated, demo_name_formated);
	/* DEMO録画開始 */
	ServerCommand("tv_record \"%s\"", full_path);
	PrintToServer("Recording Start");

}

public Action:DemoRecordStop(Handle:timer){

	/* DEMO録画停止 */
	ServerCommand("tv_stoprecord");
	PrintToServer("Recording Stop");

}

CreateDirectory_EX(){

	char directory_piece[32][PLATFORM_MAX_PATH];
	char directory_name[PLATFORM_MAX_PATH];
	
	/* スラッシュごとに分割 */
	int explode_count = ExplodeString(demo_directory_formated, "/", directory_piece, sizeof(directory_piece), sizeof(directory_piece[]));

	/* exploade_countだけ */
	for(int i=0 ; i < explode_count ; i++){
		
		Format(directory_name, sizeof(directory_name), "%s/%s", directory_name, directory_piece[i]);
		
		if(!DirExists(directory_name)){

			CreateDirectory(directory_name, 509);

		}

	}

}

/**********************************
* SayCommand
* テキストチャットのコマンド
**********************************/
public Action:Command_Say(client, args){
	
	new String:text[64];				//発言内容保存
	GetCmdArg(1, text, sizeof(text));	//発言内容取得
	
	/* ネイティブプラグインを使用している場合は試合開始コマンド発言後にDEMO録画開始 */
	if( GetConVarInt(cvar_mss_demo_native_plugin) == 1 ){
		
		if( (StrEqual(text, "!live", true)) || (StrEqual(text, "!lo3", true))){
			
			if(in_game == false){
				in_game = true;
				CreateTimer(0.0, DemoRecordStart);
			}
		
		}
		else if( (StrEqual(text, "!knife", true))){
			
			if(in_game == false){
				in_game = true;
				CreateTimer(0.0, DemoRecordStart);
			}

		}
		else if( (StrEqual(text, "!scrim", true)) || (StrEqual(text, "!30r", true))){
			
			if(in_game == false){
				in_game = true;
				CreateTimer(0.0, DemoRecordStart);
			}

		}
		else if( (StrEqual(text, "!restart", true)) ){
			
			if(in_game == true){
				in_game = false;
				CreateTimer(1.0, DemoRecordStop);
			}

		}
		
	}
}