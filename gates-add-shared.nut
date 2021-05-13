/* ---------------------------------------
       Gates System by heisenberg/blake
   ---------------------------------------*/
   
//-------------------------//   
  
enum PacketGates{
   DC_START_GATES = 2408,
   DC_OPEN_GATE_RENDER = 2409,
   DC_OPEN_GATE = 2410,
   DC_CLOSE_GATE_RENDER = 2411,
   DC_CLOSE_GATE = 2412,
   DC_GATES_STATUS_OP = 2413,
}

//-------------------------//
/* EXAMPLE NEWWORLD.ZEN-Khorinis */
local gate1 = addGate(0,true, "EVT_GATE_LARGE_01.3DS");
gate1.setPositionOpened(5636.732421875,345.828,5498.1176757813,0,-30,0);
gate1.setPositionClosed(5636.732421875,750.828,5498.1176757813,0,-30,0);

local gate2 = addGate(1,false);
gate2.setPositionOpened(6477.8559570313,348.18676757813,8207.939453125,0,-120,0);
gate2.setPositionClosed(6477.8559570313,788.18676757813,8207.939453125,0,-120,0);

local gate3 = addGate(2);
gate3.setPositionOpened(10377.612304688,-136.71270751953,5739.4677734375,0,56,0);
gate3.setPositionClosed(10377.612304688,453.28729248047,5739.4677734375,0,56,0);

local gate4 = addGate(3);
gate4.setPositionOpened(8019.763671875,-131.72393798828,-6101.6518554688,0,6,0);
gate4.setPositionClosed(8019.763671875,458.27606201172,-6101.6518554688,0,6,0);
