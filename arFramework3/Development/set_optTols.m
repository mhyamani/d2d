% set_optTols
% 
% Adaptation of integration tolerance during optimization depending on
% scaling of the states in the observables.
% 
% This function modifies Matlabs snls.m to choose integration accuracies
% depending on scaling parameters. A new function snls is created which
% might serve as an alternative to matlab's snls. 
% 
% Matlab's function is used to satisfy for potential copyright conflicts.
% 
% To better understand how snls is modified, compare both versions, e.g. by
% a diff.
% 
% If you want to return to matlab's original code, the created function has
% to be removed or the matlab search path has to be chosen properly.
% 
% See also l1trdog
% 
% Example:
% which('snls','-all')
% set_optTols
% which('snls','-all')

function set_optTols

checksum_snls   = 'e626595261d4e4aa5eb8b93f3504478c'; % Modified snls.m

snlspath = which('snls','-all');
ar_path = fileparts(which('arInit.m'));

snls_opt   = 0;
keystart_check = 'if(~isempty(ar) && isfield(ar.config,''useTolTrustPar'') && ar.config.useTolTrustPar == 1)';

for i = 1:length(snlspath)
    if strcmp(md5(snlspath{i}),checksum_snls)
        % found modified snls.m
        snls_opt = i;
    end
    
    fileID = fopen(snlspath{i});
    A = fread(fileID,'*char')';
    fclose(fileID);
    check_start = strfind(A,keystart_check);
    if(~isempty(check_start))
        snls_opt = i;
    end
end

if strcmp(md5(snlspath{1}),checksum_snls)
    % All good
    return
end
    
modified = 0;
if snls_opt == 0
    % Modify original snls.m for optimization algorithms
    fileID = fopen(snlspath{1});
    A = fread(fileID,'*char')';
    fclose(fileID);
    
    keystart{1} = 'formatstr = '' %5.0f      %5.0f   %13.6g  %13.6g   %12.3g      %7.0f''';
    keystart{2}  = '%       Determine the trust region correction';
    keystart{3}  = 'ratio = (0.5*(newval-val)+aug)/qp;     % we compute val = f''*f, not val = 0.5*(f''*f)';
    keyend{3}    = '% Accept or reject trial point';
    keystart{4}  = 'JACOB = sparse(A);     % A is the Jacobian, not the gradient.';
    
    text = {};
    text{1} = sprintf(['\nglobal ar\n',...
    'if(~isempty(ar))  \n',...
    '   atol_bkp = ar.config.atol;\n',...
    '   rtol_bkp = ar.config.rtol;\n',...
    '   did_refit = 0;\n',...
    'end\n']);
    
    text{2} = sprintf(['\n %%Adjust tolerances to trust region\n',...
      'if(~isempty(ar) && isfield(ar.config,''useTolTrustPar'') && ar.config.useTolTrustPar == 1)\n',...
      '  deltaTol_factor = 1.e-3;\n',...
      'ddxdtdp = NaN(length(ar.model(1).xNames),sum(ar.qDynamic==1),length(ar.model(1).condition)); \n',...
      '%collect RHS derivatives \n',...
      'for ix = 1:length(ar.model(1).condition) \n',...
      '   ddxdtdp_tmp = arTrafoParameters(ar.model(1).condition(ix).ddxdtdp,1,ix,false); \n',...
      '   cols_tmp = ismember(ar.pLabel(ar.qDynamic==1),ar.model(1).condition(ix).p); \n',...
      '   ddxdtdp(:,cols_tmp,ix) = ddxdtdp_tmp;          \n',...
      'end \n',...
      'ddxdtdp_collated = max(ddxdtdp,[],3); \n',...
      'change_xs = ddxdtdp_collated * sx(ar.qDynamic==1); \n',...
      '  if(deltaTol_factor*delta>ar.config.maxtol && deltaTol_factor*delta<min(change_xs)) %<atol_bkp) \n',...
      '      ar.config.atol = deltaTol_factor*delta; \n',...
      '      ar.config.rtol = deltaTol_factor*delta; \n',...
      '  elseif(deltaTol_factor*delta<ar.config.maxtol)\n',...
      '      ar.config.atol = ar.config.maxtol;\n',...
      '      ar.config.rtol = ar.config.maxtol;\n',...
      '  else\n',...
      '      ar.config.atol = atol_bkp;\n',...
      '      ar.config.rtol = rtol_bkp;\n',...
      '  end\n',...
      'end\n\n']);


    text{3} = sprintf(['\n          if (ratio >= .75) && (nrmsx >= .9*delta)\n',...
      '        if(~isempty(ar) && isfield(ar.config,''useTolSwitching'') && ar.config.useTolSwitching == 1)\n',...
      '            delta = 2*delta;\n',...
      '            ar.config.atol = atol_bkp;\n',...
      '            ar.config.rtol = rtol_bkp;\n',...
      '        else\n',...
      '          delta = 2*delta;\n',...
      '        end\n',...
      '    elseif ratio <= .25,\n',...
      '        if(~isempty(ar) && isfield(ar.config,''useTolSwitching'') && ar.config.useTolSwitching == 1)\n',...
      '            if(did_refit)\n',...
      '                delta = min(nrmsx/4,delta/4);\n',...
      '                did_refit = 0;\n',...
      '                ar.config.atol = atol_bkp;  \n',...
      '                ar.config.rtol = rtol_bkp;  \n',...
      '            else\n',...
      '                delta = min(nrmsx,delta);\n',...
      '                ar.config.atol = 1.e-3*atol_bkp;\n',...
      '                ar.config.rtol = 1.e-3*rtol_bkp;\n',...
      '                if(ar.config.atol<ar.config.maxtol)\n',...
      '                    ar.config.atol=ar.config.maxtol;\n',...
      '                end\n',...
      '                if(ar.config.rtol<ar.config.maxtol)\n',...
      '                    ar.config.rtol=ar.config.maxtol;\n',...
      '                end\n',...
      '                did_refit = 1;\n',...
      '            end\n',...
      '        else\n',...
      '            delta = min(nrmsx/4,delta/4);\n',...
      '        end\n',...
      '    else\n',...
      '        if(~isempty(ar) && isfield(ar.config,''useTolSwitching'') && ar.config.useTolSwitching == 1 && did_refit)\n',...
      '            did_refit = 0;\n',...
      '            ar.config.atol = atol_bkp; \n',...
      '            ar.config.rtol = rtol_bkp; \n',...
      '        end\n',...
      '    end\n',...
      'end\n\n']);

      text{4} = sprintf(['\nif(~isempty(ar))  \n',...
    '   ar.config.atol = atol_bkp;\n',...
    '   ar.config.rtol = rtol_bkp;\n',...
    'end\n']);
    
    posstart = strfind(A,keystart{1});            
    A_new = A;
    A_new = [A_new(1:posstart+length(keystart{1})) text{1} A_new(posstart+length(keystart{1})+1:end)];
    
    posstart = strfind(A_new,keystart{2});    
    A_new = [A_new(1:posstart-1) text{2} A_new(posstart:end)];
    
    posstart = strfind(A_new,keystart{3});
    posend   = strfind(A_new,keyend{3});
    A_new = [A_new(1:posstart+length(keystart{3})) text{3} A_new(posend-1:end)];
    
    posstart = strfind(A_new,keystart{4});    
    A_new = [A_new(1:posstart+length(keystart{4})) text{4} A_new(posstart+length(keystart{4})+1:end)];
    
    fileID = fopen([ar_path '/Subfunctions/snls.m'],'w');
    fwrite(fileID,A_new,'char');
    fclose(fileID);
    
    modified = 1;
end

if snls_opt > 0;
    % snls.m needed for optimization is shadowed by some other snls.m
    warning('Please remove file %s.\n',snlspath{1})
    return
end

if modified == 0;
    warning('No snls.m file found.')
end


function md5hash = md5(filename)

mddigest   = java.security.MessageDigest.getInstance('MD5'); 
filestream = java.io.FileInputStream(java.io.File(filename)); 
digestream = java.security.DigestInputStream(filestream,mddigest);

while(digestream.read() ~= -1) end

md5hash=reshape(dec2hex(typecast(mddigest.digest(),'uint8'))',1,[]);