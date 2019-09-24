clear;
close all;

% Crea el objeto Scorbot y asociados. Se le pasa el modo como par�metro
s=Scorbot(Scorbot.MODEVREP); 
s.home;

% Usar la pistola o cargar las posiciones con un archivo .mat
teach = 0; 
if (~teach)
	load('posiciones.mat');
else % definici�n de las 4 posiciones necesarias mediante la pistola de programaci�n
	fprintf('----> Indica al robot la posici�n de aproximaci�n y pulsa Enter para terminar.\n\n');
	apsuministro=s.pendant();
    fprintf('----> Indica al robot la posici�n d�nde coger la pieza.\n\n');
	suministro=s.pendant();
	fprintf('----> Indica al robot la posici�n de aproximaci�n a la torre.\n\n');
	aptorre=s.pendant();
	fprintf('----> Indica al robot la posici�n d�nde dejar la pieza.\n\n');
	torre=s.pendant();
end

%**************
% START PROGRAM
%**************

fprintf('Press any key to start picking-and-placing.\n');
pause;

%{ 
Para suministrar una a una las piezas al robot tal y como se muestra en el v�deo de
ejemplo, es necesario ir ubicando las piezas en la posici�n de suministro

Podemos hacer esto desde MATLAB, en vez de hacerlo manualmente en V-REP

Para cambiar la posici�n de las piezas desde MATLAB hay que crear un
manejador para cada pieza que queramos mover, ya que se precisa como
argumento en la funci�n de modificaci�n de la posici�n

Para crear los manejadores y usar las funciones de la API, es necesario
establecer una conexi�n con la misma

Se pueden consultar las funciones de la API en este enlace:
http://www.coppeliarobotics.com/helpFiles/en/remoteApiFunctionsMatlab.htm
%} 

% Establecimiento de conexi�n con la API
vrep=remApi('remoteApi');
vrep.simxFinish(-1);
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);

% Creaci�n de los manejadores para cada pieza
[res1, pieza1_handle] = vrep.simxGetObjectHandle(clientID,'Piece_1',vrep.simx_opmode_oneshot_wait);
[res2, pieza2_handle] = vrep.simxGetObjectHandle(clientID,'Piece_2',vrep.simx_opmode_oneshot_wait);
[res3, pieza3_handle] = vrep.simxGetObjectHandle(clientID,'Piece_3',vrep.simx_opmode_oneshot_wait);

% Esta funci�n devuelve la posici�n (x,y,z) de la pieza 
%[returnCode, piezas] = vrep.simxGetObjectPosition(clientID, pieza1_handle, -1, vrep.simx_opmode_oneshot_wait);

% Esta ser� la posici�n donde se suministrar�n las piezas
piezas = [0.25620000 -0.25920000 0.035000000];

% Rotaci�n sobre el eje Y para la tercera pieza (c�lculo de los �ngulos)
%[res4,angles_pieza3] = vrep.simxGetObjectOrientation(clientID, pieza3_handle, -1, vrep.simx_opmode_oneshot_wait);
euler_pieza3 = [0 -1.5707964 -5.5673134e-08];

% cambio de velocidad
speed = 50; 
s.changeSpeed(speed); 

% Secuencia de instrucciones 

% Primera pieza
fprintf('Primera pieza\n');
s.move(apsuministro,1); % aproximaci�n a la pieza
s.changeGripper(1); % abre pinza
% Llevo la primera pieza a la posici�n de suministro
vrep.simxSetObjectPosition(clientID, pieza1_handle, -1, piezas, vrep.simx_opmode_oneshot_wait);
%suministro=s.pendant();
s.changeSpeed(15); % bajo la velocidad para mayor precisi�n
s.move(suministro,1); % en posici�n para coger la pieza
s.changeGripper(0); % coge la pieza
s.changeSpeed(50); 
s.move(apsuministro,1); % vuelve al punto de aproximaci�n a la pieza
s.move(aptorre,1); % aproximaci�n a la torre
%torre=s.pendant();
s.changeSpeed(15); 
s.move(torre,1); % llega a la torre
s.changeGripper(1); % deja la pieza
s.changeSpeed(50); 
s.move(aptorre,1); % vuelve al punto de aproximaci�n a la torre

% Segunda pieza
fprintf('Segunda pieza\n');
s.move(apsuministro,1); 
% Llevo la segunda pieza a la posici�n de suministro
vrep.simxSetObjectPosition(clientID, pieza2_handle, -1, piezas, vrep.simx_opmode_oneshot_wait);
s.changeSpeed(15); 
s.move(suministro,1);
s.changeGripper(0); 
s.changeSpeed(50); 
s.move(apsuministro,1);
s.move(aptorre,1); 
vaux = torre; % uso una variable posicional auxiliar y la modifico seg�n la necesidad
vaux = s.changePosXYZ(vaux, [vaux.xyz(1)-90 vaux.xyz(2)+500 vaux.xyz(3)]);
s.changeSpeed(15);
s.move(vaux,1);
s.changeGripper(1);
s.changeSpeed(50);
s.move(aptorre,1);

% Tercera pieza
fprintf('Tercera pieza\n');
s.move(apsuministro,1);
% Llevo la tercera pieza a la posici�n de suministro
vrep.simxSetObjectPosition(clientID, pieza3_handle, -1, piezas, vrep.simx_opmode_oneshot_wait);
% Roto la tercera pieza para que aparezca tumbada
vrep.simxSetObjectOrientation(clientID, pieza3_handle, -1, euler_pieza3, vrep.simx_opmode_oneshot_wait);
s.changeSpeed(15);
s.move(suministro,1);
s.changeGripper(0);
s.changeSpeed(50);
s.move(apsuministro,1);
vaux = torre;
vaux = s.changePosXYZ(vaux, [vaux.xyz(1)-20 vaux.xyz(2) vaux.xyz(3)]);
vaux = s.changePosXYZ(vaux, [vaux.xyz(1) vaux.xyz(2) vaux.xyz(3)+700]);
vaux = s.changePosXYZ(vaux, [vaux.xyz(1) vaux.xyz(2)+250 vaux.xyz(3)]);
s.move(aptorre,1);
s.changeSpeed(15);
s.move(vaux,1); 
s.changeGripper(1); 
s.changeSpeed(50);
s.move(aptorre,1); 

% Termino ordenadamente, borrando el objeto Scorbot
s.home();
fprintf('Pulsa una tecla para borrar el objeto Scorbot.\n');
pause;
clear s;

%{ 
Fuentes:
http://www.coppeliarobotics.com/helpFiles/en/remoteApiFunctionsMatlab.htm
http://www.forum.coppeliarobotics.com/viewtopic.php?f=9&t=2403
http://www.forum.coppeliarobotics.com/viewtopic.php?f=9&t=127
%}

