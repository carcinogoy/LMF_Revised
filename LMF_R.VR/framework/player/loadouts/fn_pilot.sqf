// PLAYER GEAR SCRIPT /////////////////////////////////////////////////////////////////////////////
/*
	* Author: G4rrus
	* Apply Loadout.
	* Note: Needs to be local to the object.
	*
	* Arguments:
	* 0: Unit <OBJECT>
	*
	* Example:
	* [cursorObject] call lmf_loadout_fnc_pilot;
	*
	* Return Value:
	* <BOOL> true if settings were applied, else false
*/
// INIT ///////////////////////////////////////////////////////////////////////////////////////////
params [["_unit",objNull,[objNull]]];

//EXIT IF NOT LOCAL OR NULL
if (isNull _unit || {!local _unit}) exitWith {false};

#include "..\..\..\settings\cfg_Player.sqf"


// APPLY NEW ROLE SPECIFIC LOADOUT ////////////////////////////////////////////////////////////////
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;

//CLOTHING
_unit forceAddUniform selectRandom _Plane_Uniform;
_unit addVest selectRandom _Plane_Vest;
_unit addBackpack selectRandom _Backpack_Pilot;
_unit addHeadgear selectRandom _Plane_Headgear;
if (_Goggles#0 !=  "") then {
	removeGoggles _unit;
	_unit addGoggles selectRandom _Goggles;
};

//RADIO SETUP
_unit linkItem "ItemWatch";
_unit linkItem "ItemRadioAcreFlagged";
_unit addItem _Radio_L;
if (var_personalRadio) then {
	_unit addItem _Radio_R;
};

//LINKED ITEMS
_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
if (var_playerNVG != 2) then {_unit linkItem _NVG_Pilot};

//ITEMS
for "_i" from 1 to 2 do {_unit addItem "FirstAidKit"};
_unit addItem "ACE_Flashlight_XL50";
for "_i" from 1 to 4 do {_unit addItem _FlareGun_Ammo;};

//SIDEARM
if (_Pistol_Ammo select 0 == "") then {_Pistol_Ammo = 0;} else {_Pistol_Ammo = selectRandom _Pistol_Ammo};
[_unit, selectRandom _Pistol, 3, _Pistol_Ammo] call BIS_fnc_addWeapon;
_unit addHandgunItem (selectRandom _Pistol_Attach1);
_unit addHandgunItem (selectRandom _Pistol_Attach2);

//FLAREGUN
_unit addItemToBackpack _FlareGun;

//TRAITS
_unit setUnitTrait ["medic",false];
_unit setUnitTrait ["engineer",true];

//RANK
_unit setRank "CAPTAIN";

//EXTRA GEAR
if (count lmf_loadout_fnc_pilot_Extra != 0) {
	{
		if (count _x == 2) {
			if (_x select 1 == 1) {
				_unit addItem (_x sekect 0);
			} else {
				for "_i" from 1 to (_x select 1) do {_unit addItem (_x sekect 0);};
			}
		}
	} forEach lmf_loadout_fnc_pilot_Extra;
};
if (count lmf_loadout_fnc_All_Extra != 0) {
	{
		if (count _x == 2) {
			if (_x select 1 == 1) {
				_unit addItem (_x sekect 0);
			} else {
				for "_i" from 1 to (_x select 1) do {_unit addItem (_x sekect 0);};
			}
		}
	} forEach lmf_loadout_fnc_All_Extra;
};

// RETURN /////////////////////////////////////////////////////////////////////////////////////////
true