/* ---------------------------------------
       Gates System by heisenberg/blake
   ---------------------------------------*/

const manipulation_distance = 270; //dystans do wpisania komendy
const manipulation_range = 1800; //dystans do animacji zamykania bramy
const manipulation_msg = 900; //dystans do otrzymania wiadomosci o akcji

//-------------------------//

function enabledGatesSystem(bool = false) {
   enabled_gates=bool;
   if(!(enabled_gates)) return;
   
  local query = mysql_query("SELECT * FROM `gates`")
  
  if(!(query)) return
  if(mysql_num_rows(query) <= 0) return
  
	local data;
    while(data = mysql_fetch_assoc(query)) 
	   gates[data["id"]].m_opened = data["opened"];
}

//-------------------------//

function readGatesToClient(pid){
   foreach(val in gates){
    local packet = Packet()
	packet.writeUInt16(PacketGates.DC_GATES_STATUS_OP)
	packet.writeUInt16(val.getId())
	packet.writeBool(val.m_opened)
	packet.send(pid, RELIABLE)
   }

   local packet = Packet()
   packet.writeUInt16(PacketGates.DC_START_GATES)
   packet.send(pid, RELIABLE)
}

//-------------------------//

local function cmd_gates_open(pid, params)
{
   local pos = getPlayerPosition(pid);
    if(!(enabled_gates)) return;
    foreach(i, val in gates){
	    if(getDistance2d(pos.x, pos.z, val.pos_opened.x, val.pos_opened.z) <= manipulation_distance){
		    if(val.getOpened()) {sendMessageToPlayer(pid, 255, 0,0, "Ta brama jest ju¿ otwarta!"); return;}
		    if(!(GatesPermission[pid])){sendMessageToPlayer(pid, 255, 0,0, "Nie posiadasz uprawnieñ do otwarcia bramy"); return;}
			val.m_opened = true;
			mysql_query(format("UPDATE `gates` SET `opened` = %d WHERE `id` = %d LIMIT 1", 1, i));
			
            for(local _i = 0; _i < getMaxSlots(); _i++){
                if (isPlayerConnected(_i)){
				   local _pos = getPlayerPosition(_i);
				   if(getDistance2d(_pos.x, _pos.z, val.pos_opened.x, val.pos_opened.z) <= manipulation_msg)
				     sendMessageToPlayer(_i, 0, 255,0, "# "+getPlayerName(pid) + " otwiera brame #");
					 
					if(getDistance2d(_pos.x, _pos.z, val.pos_opened.x, val.pos_opened.z) <= manipulation_range){
					   local packet = Packet();
					   packet.writeUInt16(PacketGates.DC_OPEN_GATE_RENDER);
					   packet.writeUInt16(val.getId());
					   packet.send(_i, RELIABLE);
					}
					else{
					   local packet = Packet();
					   packet.writeUInt16(PacketGates.DC_OPEN_GATE);
					   packet.writeUInt16(val.getId());
					   packet.send(_i, RELIABLE);
					}
			    }
			}
			return;
	    }
    }
}

//-------------------------//

local function cmd_gates_close(pid, params)
{
   local pos = getPlayerPosition(pid);
    if(!(enabled_gates)) return;
    foreach(i, val in gates){
	    if(getDistance2d(pos.x, pos.z, val.pos_opened.x, val.pos_opened.z) <= manipulation_distance){
		    if(!(val.getOpened())) {sendMessageToPlayer(pid, 255, 0,0, "Ta brama jest ju¿ zamkniêta!"); return;}
		    if(!(GatesPermission[pid])){sendMessageToPlayer(pid, 255, 0,0, "Nie posiadasz uprawnieñ do zamkniêcia bramy"); return;}
			val.m_opened = false;
			mysql_query(format("UPDATE `gates` SET `opened` = %d WHERE `id` = %d LIMIT 1", 0, i));
			
            for(local _i = 0; _i < getMaxSlots(); _i++){
                if (isPlayerConnected(_i)){
				   local _pos = getPlayerPosition(_i);
				   if(getDistance2d(_pos.x, _pos.z, val.pos_opened.x, val.pos_opened.z) <= manipulation_msg)
				     sendMessageToPlayer(_i, 0, 255,0, "# "+getPlayerName(pid) + " zamyka brame #");
					 
					if(getDistance2d(_pos.x, _pos.z, val.pos_opened.x, val.pos_opened.z) <= manipulation_range){
					   local packet = Packet();
					   packet.writeUInt16(PacketGates.DC_CLOSE_GATE_RENDER);
					   packet.writeUInt16(val.getId());
					   packet.send(_i, RELIABLE);
					}
					else{
					   local packet = Packet();
					   packet.writeUInt16(PacketGates.DC_CLOSE_GATE);
					   packet.writeUInt16(val.getId());
					   packet.send(_i, RELIABLE);
					}
			    }
			}
			return;
	    }
    }
}

//-------------------------//

local function cmd_gates_login(pid, params)
{
    local args = sscanf("s", params);
    if(!args)
    {
       sendMessageToPlayer(pid, 255, 0, 0, "/gate <pass>");
       return;
    }
	
	  if(!(enabled_gates)) return;

    if(args[0].toupper() == getPassGates().toupper()) {
	  GatesPermission[pid] = true;
	  sendMessageToPlayer(pid, 0, 255, 0, "Nadano uprawnienia do u¿ywania bram");
	}
	else {
	  sendMessageToPlayer(pid, 255, 255, 255, "B³êdne has³o.");
	}
}

local function cmdHandler(pid, cmd, params)
{
	switch (cmd.toupper())
	{
	case "OPEN": case "O":
		cmd_gates_open(pid, params);
		break;
	case "CLOSE": case "C":
		cmd_gates_close(pid, params);
		break;
	case "GATE": case "GATES":
	    cmd_gates_login(pid, params);
	    break;
	}
}

addEventHandler("onPlayerCommand", cmdHandler);

//-------------------------//