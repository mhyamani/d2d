% Add steady state pre-simulation
%
% Usage:
%   arAddEvent((ar), model, conditionSS, conditionAffected, (tstart) )
%
% Adds a steady state presimulation to a number of conditions. Here
% conditionSS refers to the condition the steady state is taken from. Note
% that the condition events of the steady state simulation condition
% are ignored. However, input functions will behave as they were for that
% specific condition. In many cases, it is therefore desirable to use a
% steady state condition with no inputs.
%
% The optional argument tstart refers to the starting timepoint of the 
% steady state simulation.
%
% For the target conditions, note that any event at tStart will be 
% overwritten by the steady state. If an event immediately upon start is 
% required (for example, concentration = 2*steadystate), consider placing 
% your events beyond tstart and shifting the entire simulation.
%
% Hint: If you wish to see how the conditions are set up, you can use 
% the command 'arShowDataConditionStructure'
%
% Hint: To clear arSteadyState's changes to the model, invoke
% "arClearEvents". Note that this also clears other events.
%
% Notes:
%    arSteadyState invokes arLink
%    arSteadyState is currently only supported for deterministic
%    simulations
%    Steady state simulations will not check whether a stable steady state
%    exists. If this is not the case, pre-equilibration will fail and
%    an error will be thrown.

function ar = arSteadyState( varargin )

    global ar;
    
    if ( nargin < 3 )
        error( 'Function needs at least three arguments.' );
    end
    if ( isstruct(varargin{1}) )
        ar = varargin{1};
        varargin = varargin(2:end);
    end
    
    m       = varargin{1};
    cSS     = varargin{2};
    cTarget = varargin{3};
    
    tstart = 0;
    if ( length(varargin)>3 )
        tstart = varargin{4};
    end
    
    if ( ischar(cTarget) )
        if ( strcmp( cTarget, 'all' ) )
            cTarget = 1 : length(ar.model(m).condition);
        else
            error( 'Invalid target condition. Specify either a number or ''all''.' );
        end
    end

    % Set up the steady state condition
    % Note that the explicit manual copy is intentional since in R2013
    % structure copies tend to be shallow copies.
    origin                  = ar.model(m).condition(cSS);
    ss_condition.src        = cSS;
    ss_condition.fkt        = origin.fkt;
    ss_condition.checkstr   = origin.checkstr;
    ss_condition.p          = origin.p;
    ss_condition.pLink      = origin.pLink;
    ss_condition.status     = 0;
    ss_condition.dLink      = [];
    ss_condition.pNum       = zeros(size(origin.pNum));
    ss_condition.qLog10     = zeros(size(origin.pNum));
    ss_condition.uNum       = zeros(size(origin.uNum));
    ss_condition.vNum       = zeros(size(origin.vNum));    
    ss_condition.suNum      = zeros(size(origin.suNum));
    ss_condition.svNum      = zeros(size(origin.svNum));
    ss_condition.dvdxNum    = zeros(size(origin.dvdxNum));
    ss_condition.dvduNum    = zeros(size(origin.dvduNum));
    ss_condition.dvdpNum    = zeros(size(origin.dvdpNum));
    ss_condition.svNum      = zeros(size(origin.svNum));    
    ss_condition.y_atol     = origin.y_atol;
    ss_condition.tstart     = tstart;
    ss_condition.tstop      = 1;
    ss_condition.tFine      = [tstart,inf];
    ss_condition.t          = [tstart,inf];
    ss_condition.tEq        = nan;
    ss_condition.dLink      = [];
    ss_condition.tEvents    = [];
    ss_condition.modx_A     = [];
    ss_condition.modx_B     = [];
    ss_condition.modsx_A    = [];
    ss_condition.modsx_B    = [];
    ss_condition.has_tExp   = 0;
    ss_condition.qEvents    = 0;
    ss_condition.uFineSimu  = zeros(2, size(origin.uFineSimu,2));
    ss_condition.vFineSimu  = zeros(2, size(origin.vFineSimu,2));
    ss_condition.xFineSimu  = zeros(2, size(origin.xFineSimu,2));
    ss_condition.zFineSimu  = zeros(2, size(origin.zFineSimu,2));
    ss_condition.suFineSimu = [];
    ss_condition.svFineSimu = [];
    ss_condition.sxFineSimu = [];
    ss_condition.szFineSimu = [];
    
    ss_condition.qMS        = 0;
    ss_condition.start      = 0;
    ss_condition.stop       = 0;
    ss_condition.stop_data  = 0;
    ss_condition.dxdt       = zeros(size(origin.dxdt));
    ss_condition.ddxdtdp    = zeros(size(origin.ddxdtdp));
    ss_condition.ssLink     = cTarget;
    
    if ( isfield( ar.model(m), 'ss_condition' ) )
        ar.model.ss_condition(end+1) = ss_condition;
    else
        ar.model.ss_condition = ss_condition;
    end
    insertionPoint = length(ar.model.ss_condition);
    
    h = waitbar(0, 'Linking up steady state');
    % Link up the target conditions
    for a = 1 : length( cTarget )
        waitbar(a/length(cTarget), h, sprintf('Linking up steady state %d/%d', a, length(cTarget)));
        
        % Map the parameters from the ss condition to the target condition
        fromP   = ar.model(m).condition(cSS).p;
        toP     = ar.model(m).condition(cTarget(a)).p;
        map     = mapStrings( fromP, toP );
    
        nStates = numel( ar.model(m).x );
        nPars   = numel( toP );
        ar.model(m).condition(cTarget(a)).ssParLink = map;
        ar.model(m).condition(cTarget(a)).ssLink = insertionPoint;
        
        vals = zeros(1,nStates);
        sens = zeros(1,nStates,nPars);
        
        ar = arAddEvent(ar, m, cTarget(a), ...
            ar.model(m).condition(cTarget(a)).tstart, ...
            [1:nStates], vals, vals, sens, sens, false );
    end
    close(h);
    
    ar.ss_conditions = true;
    
    % The event addition requires linking (silent link)
    arLink(true);
    
    % Show usercount (to prevent users from forgetting arClearEvents)
    cnt = 0;
    for a = 1 : length( ar.model )
        cnt = cnt + length(ar.model(m).ss_condition);
    end
    disp( sprintf( 'Number of steady state equilibrations: %d', cnt ) );
end

function ID = mapStrings( str1, str2 )
    ID = nan(length(str2), 1);
    for a = 1 : length( str2 )
        for b = 1 : length( str1 )
            if strcmp( str1(b), str2(a) )
                if isnan( ID(a) )
                    ID(a) = b;
                else
                    error( 'Duplicate parameter name in ar.model.condition.p' );
                end
            end
        end
    end
end