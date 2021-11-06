function plotFieldOnMesh(nodeCoordinates, elements, valuesArray)
%% NOTE: this is an inner function which should not be directly used. 
%In order to plot data on the mesh use 'plotDataOnMesh'

% this function is a revision of PlotFieldonMesh from postprocessing
% toolbox. It essentially allows to plot field values on 3D objects (e.g
% displacement values on 3D objects). It can be used both with 3D (x, y, z)
% and 2D (x, y) meshes. Actually, only the 3D triangular case of surface
% meshes has been revisioned. Other cases should be carefully tested and
% revisioned before being able to work properly.

dimension = size(nodeCoordinates,2) ;  % Dimension of the mesh
numberOfElements = length(elements) ;  % number of elements
numberOfNodesPerElement = size(elements,2); % number of nodes per element

% Initialization of the required matrices
X = zeros(numberOfNodesPerElement, numberOfElements) ;
Y = zeros(numberOfNodesPerElement, numberOfElements) ;
Z = zeros(numberOfNodesPerElement, numberOfElements) ;
field = zeros(numberOfNodesPerElement, numberOfElements) ;

if dimension == 3   % For 3D plots 
    if numberOfNodesPerElement == 3 % triangular faces
        for iel=1:numberOfElements   
            elem = elements(iel,:);         % extract the i-eth element
            X(:, iel)=nodeCoordinates(elem, 1);    % extract x values of the element
            Y(:, iel)=nodeCoordinates(elem, 2);    % extract y values of the element
            Z(:, iel)=nodeCoordinates(elem, 3) ;   % extract z values of the element
            field(:, iel) = valuesArray(elem') ; % extract component values of the element 
        end
        % Plotting the FEM mesh and profile of the given component
        %figure(h);
        fill3(X, Y, Z, field, 'LineStyle', 'none');
        %rotate3d on ;
        
        
        %title(figureTitle) ;  
        axis equal;
        minZ = min(min(Z))-abs(min(min(Z))*0.5);
        maxZ = max(max(Z))-abs(max(max(Z))*0.5);
        
        if maxZ-minZ == 0
            view(2);
        end
        
        grid on;
        
        view(2);
        
        %axis([min(nodeCoordinates(:, 1)) max(nodeCoordinates(:, 1)) min(nodeCoordinates(:, 2)) max(nodeCoordinates(:, 2)) -0.1 0.1]);
       
        % Colorbar Setting
        %setColorbar;
        
    elseif numberOfNodesPerElement == 8  % hexaedron in 3D
        fm = [1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8];
        XYZ = cell(1,numberOfElements) ;
        field = XYZ ;
        for e=1:numberOfElements
            elem=elements(e,:);
            X = nodeCoordinates(elem,1) ;
            Y = nodeCoordinates(elem,2) ;
            Z = nodeCoordinates(elem,3) ;
            XYZ{e} = [X  Y Z] ;
            field{e} = valuesArray(elem) ;
        end
        figure
        cellfun(@patch,repmat({'Vertices'},1,numberOfElements),XYZ,.......
            repmat({'Faces'},1,numberOfElements),repmat({fm},1,numberOfElements),......
            repmat({'FaceVertexCdata'},1,numberOfElements),field,......
            repmat({'FaceColor'},1,numberOfElements),repmat({'interp'},1,numberOfElements));
        view(3)
        set(gca,'XTick',[]) ; set(gca,'YTick',[]); set(gca,'ZTick',[]) ;
        % Colorbar Setting
        setColorbar
        
    end
    
elseif dimension == 2 % For 2D plots
    
    for iel=1:numberOfElements   
        elem=elements(iel,:);         % extract connected node for (iel)-th element
        X(:,iel)=nodeCoordinates(elem,1);    % extract x value of the node
        Y(:,iel)=nodeCoordinates(elem,2);    % extract y value of the node
        field(:,iel) = valuesArray(elem') ;         % extract component value of the node 
    end
    % Plotting the FEM mesh and profile of the given component
    figure
    % plot(X,Y,'k')
    fill(X,Y,field)
    title(figureTitle) ;         
    axis off ;
    % Colorbar Setting
    mySetColorbar
end

              
         
 
   
     
       
       

