/* ---------------------------------------
       Gates System by heisenberg/blake
   ---------------------------------------*/

enabled_gates <- false;
local gates_permission = false;
GatesPermission <- array(getMaxSlots())
for (local i = 0; i < getMaxSlots(); i++)
    GatesPermission[i] = false;
	
local gates_pass = "gate123";
function getPassGates(){return gates_pass}

//-------------------------//

addEventHandler("onInit",function()
{
   enabledGatesSystem(true) //system włączony
   gates_permission = false; //Bez uprawnień nie można otwierać
})

//-------------------------//

addEventHandler("onPlayerJoin", function(pid)
{
    if(enabled_gates){
	  readGatesToClient(pid);
	  
	  if(gates_permission) GatesPermission[pid] = true;
    }
})

//-------------------------//

addEventHandler("onPlayerDisconnect", function(pid, reason)
{
    if(enabled_gates)
	  GatesPermission[pid] = false;
});

//-------------------------//