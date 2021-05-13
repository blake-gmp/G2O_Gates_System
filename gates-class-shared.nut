/* ---------------------------------------
       Gates System by heisenberg/blake
   ---------------------------------------*/

gates <- {};

//-------------------------//

class addGate{
    m_id = null
	m_opened = null
	m_visual = null
	pos_opened = null
	pos_closed = null
	
	moving_to_open = null
	moving_to_close = null
	
	constructor(id, opened = false, visual = "EVT_GATE_LARGE_01.3DS", world = "NEWWORLD\\NEWWORLD.ZEN")
	{
	   m_id = id
	   m_opened = false
	   m_visual = visual
	   
	   moving_to_open = false
	   moving_to_close = false
	   
	   pos_opened = {x=0,y=0,z=0,rx=0,ry=0,rz=0}
	   pos_closed = {x=0,y=0,z=0,rx=0,ry=0,rz=0}
	   
	   gates[m_id] <- this
	}
	
	function setPositionOpened(x,y,z, rx,ry,rz){
	   pos_opened.x = x; pos_opened.y = y; pos_opened.z = z;
	   pos_opened.rx = rx; pos_opened.ry = ry; pos_opened.rz = rz;
	}
	
	function setPositionClosed(x,y,z, rx,ry,rz){
	   pos_closed.x = x; pos_closed.y = y; pos_closed.z = z;
	   pos_closed.rx = rx; pos_closed.ry = ry; pos_closed.rz = rz;
	}
	
	function getOpened(){return m_opened}
	function getId(){return m_id}
	function getVisual(){return m_visual}
	function getPosOpened(){return pos_opened}
	function getPosClosed(){return pos_closed}
}

//-------------------------//