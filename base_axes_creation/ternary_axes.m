function handle = ternary_axes( var_general, var_outline, var_grid, var_tick, var_label )
% ternary_axes create basic outline, gridlines, and labels for a ternary plot
%
%   handle contains children handle groups for the outline, grid lines, tick
%   marks, tick labels, and axes labels (e.g. ax.Children.outline,
%   ax.Children.grid, etc ). 
%
%   INPUTS: (All must be in order, filled with [] if not provided, unless
%   none are provided, in which case defaults are used or nothing extra is
%   forwarded)
% 
%   (1) var_general: cell array containing options specific to ternary
%   plots, identified in pairs with identifier strings: 
%     "wlimits"        - (2x3 float ), Axis limits                (default 0-1)
%     "autoticksize"   - (true/false), Use auto tick label sizes  (default on)
%     "usegridspace"   - (true/false), Specify griddelta, not cnt (default false)
%     "gridspaceunit"  - (int/float ), Grid unit                  (default 6)
%     "ticklinelength" - (float     ), Adds ticks to the outside  (default 0.05)
%     "tick_fmt"       - (string    ), Tick text format 
%
%   (2) var_outline  - Triangle "box,"  inherited by "plot()" as varargin
%   (3) var_grid     - Grid lines,      inherited by "plot()" as varargin
%   (4) var_tick     - Tick labels,     inherited by "text()" as varargin
%   (5) var_label    - Axes Text Label, inherited by "text()" as varargin
%  
    
    %% Interpret Var_General
    
    % Create Defaults, overwrite if needed
    vg.wlimits(1,1:3) = 0; 
    vg.wlimits(2,1:3) = 1;  % default wlimits
    vg.autoticksize   = true; 
    vg.usegridspace   = false; 
    vg.gridspaceunit  = 6;
    vg.ticklinelength = 0.07; 
    vg.tick_fmt       = '%4.1f';
    
    % Overwrite fields if they are given
    if nargin>=1
        
        % Number of entries
        n = numel( var_general );
        
        % Check that gridspaceunit is given if usedgridspace is on
        if ( any(contains(var_general(1:2:n),'usegridspace' )) && ...
            ~any(contains(var_general(1:2:n),'gridspaceunit')) )
            warning('Must specify a grid spacing increment with "usegridspace" activated!')
        end
        
        % Loop through inputs x2
        for i=1:2:n
            
            % Copy string identifier to field
            field = var_general{i};
            
            % Test if it matches one of the defauls
            if ( isfield( vg, field ) )
                vg.( field ) = var_general{i+1};
            else % throw error
                warning(['Field ', field, ' was not valid. Entry ignored!'])
            end
            
        end
        
    end
    
    % Grab Current axis or create one
    ax = gca;
    
    % Apply a standard shift to improve colorbar placement
    ax.Position(1) = ax.Position(1) - 0.03;
    ax.Position(2) = ax.Position(2) - 0.06; 
    
    % Turn on hold
    hold on
    
    %% Call creation of outline frame
    handle = ternary_outlines( [], var_outline );
    
    %% Calculate axis spacing
    
    % default grid spacing
    grid_flag(1:3) = vg.usegridspace;
    
    % Create grid using gridspaceunit as distance between lines
    if (vg.usegridspace)
        
        % Loop Each Axis
        for i=1:3
            
            % Convert to plot units
            gridspace = ( vg.gridspaceunit  ) ./ ...
                         ( vg.wlimits(2,i) - vg.wlimits(1,i) ) ;
           
            % make array based on even spaced integers
            grid_pnts(i).values(:) = [0:gridspace:1.0];
            
            % Check for failure and reset/clear to normal
            if (numel(grid_pnts(i).values)<=1)
                warning('gridspaceunit failed as increment, revert to basic');
                vg.gridspaceunit = 6;
                grid_flag(i)  = false;
            end
        
        end
        
    end
    
    % Linspace grid spacing
    for i=1:3
        if (~grid_flag(i))
            grid_pnts(i).values = linspace( 0, 1, vg.gridspaceunit );
        end
    end    

    %% Call creation of grid lines
    handle = ternary_grid_lines( handle, grid_pnts, vg.ticklinelength, ...
                                 var_grid );
    
    %% Call Tick Labels
    
    
    %% Call Axis Lab
    
    %% Link axes colors together

end
