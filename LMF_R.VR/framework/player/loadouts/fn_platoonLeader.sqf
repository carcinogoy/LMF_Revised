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
	* [cursorObject] call lmf_loadout_fnc_platoonLeader;
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
_unit forceAddUniform selectRandom _Uniform_L;
_unit addVest selectRandom _Vest;
_unit addBackpack selectRandom _Backpack_Leader;
_unit addHeadgear selectRandom _Headgear_L;
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
if (var_playerMaps != 2) then {
	_unit linkItem "ItemMap";
	_unit linkItem "ItemCompass";
	_unit addItem "ACE_Flashlight_XL50";
};
if (var_playerNVG == 0) then {_unit linkItem _NVG};

//PRIMARY
[_unit,_Gun_PltL] call lmf_loadout_fnc_givePrimary;

//ITEMS
for "_i" from 1 to 2 do {_unit addItem "FirstAidKit"};
for "_i" from 1 to 2 do {_unit addItem (selectRandom _Grenade);};
_unit addItem (selectRandom _Grenade_Smoke);
for "_i" from 1 to 2 do {_unit addItem (selectRandom _Grenade_Smoke_Clr);};

//SIDEARM
if (_Pistol_Ammo select 0 == "") then {_Pistol_Ammo = 0;} else {_Pistol_Ammo = selectRandom _Pistol_Ammo};
[_unit, selectRandom _Pistol, 3, _Pistol_Ammo] call BIS_fnc_addWeapon;
_unit addHandgunItem (selectRandom _Pistol_Attach1);
_unit addHandgunItem (selectRandom _Pistol_Attach2);

_unit addWeapon _Binocular;

//TRAITS
_unit setUnitTrait ["medic",false];
_unit setUnitTrait ["engineer",false];

//RANK
_unit setRank "LIEUTENANT";

//EXTRA GEAR
if (count lmf_loadout_fnc_platoonLeader_Extra != 0) {
	{
		if (count _x == 2) {
			if (_x select 1 == 1) {
				_unit addItem (_x sekect 0);
			} else {
				for "_i" from 1 to (_x select 1) do {_unit addItem (_x sekect 0);};
			}
		}
	} forEach lmf_loadout_fnc_platoonLeader_Extra;
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