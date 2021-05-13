/* ---------------------------------------
       Gates System by heisenberg/blake
   ---------------------------------------*/
   
local gates_vob = {};
   
//-------------------------//

local function onPacketHandler(packet)
{
    local id = packet.readUInt16();

    switch(id)
    {
	   case PacketGates.DC_START_GATES:
	       createGates();
	   break;
	   
	   case PacketGates.DC_GATES_STATUS_OP:
	       local _id = packet.readUInt16();
		   local status = packet.readBool();
		   if(!(_id in gates)) return;
		   
		   gates[_id].m_opened = status;
	   break;
	   
	   case PacketGates.DC_OPEN_GATE_RENDER:
	       local _id = packet.readUInt16();
		   if(!(_id in gates)) return;
		   
		   gates_vob[_id].cdStatic = false;
		   gates_vob[_id].cdDynamic = false;
		   gates[_id].moving_to_close = false;
		   gates[_id].moving_to_open = true;
	   break;
	   case PacketGates.DC_OPEN_GATE:
	       local _id = packet.readUInt16();
		   if(!(_id in gates)) return;
		   
		   gates_vob[_id].cdStatic = false;
		   gates_vob[_id].cdDynamic = false;
	       gates_vob[_id].setPosition(val.pos_opened.x, val.pos_opened.y, val.pos_opened.z);
	       gates_vob[_id].setRotation(val.pos_opened.rx, val.pos_opened.ry, val.pos_opened.rz);
		   gates_vob[_id].cdStatic = true;
		   gates_vob[_id].cdDynamic = true;
	   break;
	   
	   case PacketGates.DC_CLOSE_GATE_RENDER:
	       local _id = packet.readUInt16();
		   if(!(_id in gates)) return;
		   
		   gates_vob[_id].cdStatic = false;
		   gates_vob[_id].cdDynamic = false;
		   gates[_id].moving_to_open = false;
		   gates[_id].moving_to_close = true;
	   break;
	   case PacketGates.DC_CLOSE_GATE:
	       local _id = packet.readUInt16();
		   if(!(_id in gates)) return;
		   
		   gates_vob[_id].cdStatic = false;
		   gates_vob[_id].cdDynamic = false;
	       gates_vob[_id].setPosition(val.pos_closed.x, val.pos_closed.y, val.pos_closed.z);
	       gates_vob[_id].setRotation(val.pos_closed.rx, val.pos_closed.ry, val.pos_closed.rz);
		   gates_vob[_id].cdStatic = true;
		   gates_vob[_id].cdDynamic = true;
	   break;
    }
}

addEventHandler("onPacket", onPacketHandler);

//-------------------------//

function createGates(){
   foreach(i,val in gates){
    local _vob = Vob(val.m_visual);
	
	if(val.m_opened){
	_vob.setPosition(val.pos_opened.x, val.pos_opened.y, val.pos_opened.z);
	_vob.setRotation(val.pos_opened.rx, val.pos_opened.ry, val.pos_opened.rz);
	}
	else{
	_vob.setPosition(val.pos_closed.x, val.pos_closed.y, val.pos_closed.z);
	_vob.setRotation(val.pos_closed.rx, val.pos_closed.ry, val.pos_closed.rz);
	}
	_vob.cdStatic = true;
	_vob.cdDynamic = true;
	gates_vob[val.m_id] <- _vob;
   }
}

//-------------------------//

local movementSpeed = 1.54;
local rendergate = 0;
addEventHandler("onRender",function()
{
   if(rendergate < getTickCount()){
        foreach(i,val in gates){
		   if(val.moving_to_open){
                local gat = gates_vob[i].getPosition();
               
                if((gat.y - movementSpeed) > val.getPosOpened().y)
                   gates_vob[i].setPosition(gat.x, gat.y - movementSpeed, gat.z);
                else{
                   val.moving_to_open = false;
				   gates_vob[i].cdStatic = true;
				   gates_vob[i].cdDynamic = true;
				   }
		    }
			if(val.moving_to_close){
                local gat = gates_vob[i].getPosition();
					
                if((gat.y + movementSpeed) < val.getPosClosed().y)
                    gates_vob[i].setPosition(gat.x, gat.y + movementSpeed, gat.z)
                else{
                    val.moving_to_close = false;
					gates_vob[i].cdStatic = true;
					gates_vob[i].cdDynamic = true;
					}
			}
	    } 
	  rendergate = getTickCount() + 6;
	}
})

//-------------------------//
print("Gates System by heisenberg/blake loaded...");