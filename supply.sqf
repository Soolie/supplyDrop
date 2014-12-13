	openMap [true,true];
	clicked = 0;
	hintc "Left click on the map where you want the supplies dropped";

	["supplymapclick", "onMapSingleClick", {
		//_supplyLocArray = [+1000,-1375,-1500,-1125,+1250,-1000,+1375,-1250,+1500,+1125];
		//Use the one below for testing. It spawns the heli much closer.
		_supplyLocArray = [+500,-500];
		_supplyRandomLocX = _supplyLocArray select floor random count _supplyLocArray;
		_supplyRandomLocY = _supplyLocArray select floor random count _supplyLocArray;
		_supply = [[(_pos select 0)+_supplyRandomLocX,
					(_pos select 1)+_supplyRandomLocY, 
					(_pos select 2)+50], 180, "I_Heli_Transport_02_F", WEST] call bis_fnc_spawnvehicle;
		_supplyHeli = _supply select 0;
		_supplyHeliPos = getPos _supplyHeli;
		_supplyMrkrHeli = createMarker ["supplyMrkrHeli", _supplyHeliPos];
		_supplyCrew = _supply select 1;
		_supplyGrp = _supply select 2;
		_supplyGrp setSpeedMode "FULL";
		_supplyGrp setBehaviour "CARELESS";
		_supplyWP1 =_supplyGrp addWaypoint [(_pos),1];
		_supplyWP1 setWaypointType "MOVE";
		_supplyWP2 = _supplyGrp addWaypoint [[(_pos select 0)+_supplyRandomLocX, 
											(_pos select 1)+_supplyRandomLocY, 
											_pos select 2], 2];
		_supplyMrkrLZ = createMarker ["supplyMrkrLZ", _pos];
		"supplyMrkrLZ" setMarkerType "Empty";
		"supplyMrkrHeli" setMarkerType "Empty";
		clicked = 1;
		openmap [false,false];
		onMapSingleClick '';}] call BIS_fnc_addStackedEventHandler; 


	waitUntil {(clicked == 1)};
		//hint "After clicked";
		_supplyMrkrHeliPos = getMarkerPos "supplyMrkrHeli";
		_supplyMrkrHeliPos2 = [_supplyMrkrHeliPos select 0, 
								_supplyMrkrHeliPos select 1, 
								(_supplyMrkrHeliPos select 2)+50];
		_supplyHeli = _supplyMrkrHeliPos2 nearestObject "I_Heli_Transport_02_F";
		_supplyMrkrLZPos = getMarkerPos "supplyMrkrLZ"; 
		_supplyLZ = createVehicle ["Land_Laptop_device_F", getMarkerPos "supplyMrkrLZ", [], 0, "NONE"];
		deleteMarker "supplyMrkrHeli";
		deleteMarker "supplyMrkrLZ";
		_supplyLZ hideObject true;
		
	waitUntil {( _supplyLZ distance _supplyHeli)<200};
		_supplyHeli animateDoor ["CargoRamp_Open",1];
		
	waitUntil {( _supplyLZ distance _supplyHeli)<100};
		sleep 1.2;
		_supplyHeli allowDammage false;     
		_supplyBox = "B_G_Quadbike_01_F" createVehicle position _supplyHeli;
						
						clearWeaponCargo _supplyBox;
						clearMagazineCargo _supplyBox;
						clearItemCargo _supplyBox;
						_supplyBox addweaponcargo ["srifle_EBR_F",10];
						_supplyBox addweaponcargo ["hgun_P07_F",10];

						_supplyBox addmagazinecargo ["20Rnd_762x51_Mag", 100];
						_supplyBox addmagazinecargo ["16Rnd_9x21_Mag", 30];
						_supplyBox addmagazinecargo ["30Rnd_9x21_Mag", 10];

						_supplyBox additemcargo ["optic_Aco", 10];
						_supplyBox additemcargo ["optic_Hamr", 10];
						_supplyBox additemcargo ["optic_Holosight", 10];
						_supplyBox additemcargo ["acc_flashlight", 10];
						_supplyBox additemcargo ["acc_pointer_IR", 10];

						_supplyBox additemcargo ["U_B_CombatUniform_mcam", 10];
						_supplyBox additemcargo ["U_B_CombatUniform_mcam_tshirt", 10];
						_supplyBox additemcargo ["U_B_CombatUniform_mcam_vest", 10];

						_supplyBox additemcargo ["H_HelmetB", 10];
						_supplyBox additemcargo ["H_HelmetB_light", 10];
						_supplyBox additemcargo ["H_HelmetB_paint", 10];

						_supplyBox additemcargo ["V_PlateCarrier1_rgr", 10];
						_supplyBox additemcargo ["V_PlateCarrier2_rgr", 10];
						_supplyBox additemcargo ["V_PlateCarrierGL_rgr", 10];

						_supplyBox addbackpackcargo ["B_AssaultPack_ocamo", 10];
					
		deleteVehicle _supplyLZ;
		_supplyBox attachTo [_supplyHeli, [0, 0, -2] ]; 
		detach _supplyBox;

	_supplyChute = createVehicle ["B_parachute_02_F", position _supplyBox, [], 0, "CAN_COLLIDE"];
	_supplyBox attachTo [_supplyChute,[0,0,-0.5]];	
	_supplyChute hideObject true;
	_supplyChute setPos getPos _supplyBox;
																			
	_supplySmoke = "SmokeShell" createVehicle (position _supplyBox);
	_supplySmoke attachTo [_supplyBox, [0,0,0]];
	_supplyLight = "Chemlight_green" createVehicle (position _supplyBox);
	_supplyLight attachTo [_supplyBox, [0,0,0]];
	
				

	sleep 1;
	_supplyChute hideObject false;
	_supplyHeli allowDammage true;
	_supplyHeli animateDoor ["CargoRamp_Open",0];
	waitUntil {(getPos _supplyBox select 2)<3}; 
	detach _supplyBox;
	sleep 10;
	{deleteVehicle _x;}forEach crew _supplyHeli;deleteVehicle _supplyHeli;
	//hint "end";
		if (cursorTarget == _supplyBox) then {
	supplyAct1 = player addaction ["Remove Light",{
														_supplyLight = nearestObject [player, "Chemlight_green"];
														deleteVehicle _supplyLight; player removeAction supplyAct1;}];};




