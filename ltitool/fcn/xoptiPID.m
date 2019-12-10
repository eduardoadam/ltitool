%
%
%
%

%% The controlled is a PID controller with second-order roll-off
%% $$ C(s) = k_p \\ (1 + {1 \\over T_i \\ s} + T_d \\ s) \\ {1 \\over (\\tau \\ s + 1)^{2}} $$
%% @example
%%                  1                1
%% C(s) = Kp (1 + ---- + Td s) -------------
%%                Ti s         (tau s + 1)^2
%% in the usual negative feedback structure
%% $$ T(s) = {L(s) \\over 1 + L(s)} = {P(s) \\ C(s) \\over 1 + P(s) \\ C(s)} $$
%% @example
%%          L(s)       P(s) C(s)
%% T(s) = -------- = -------------
%%        1 + L(s)   1 + P(s) C(s)
%% The plant P(s) is of higher order but benign.  The initial values for the
%% controller parameters
%% $k_p$, $T_i$ and $T_d$
%% Kp, Ti and Td
%% are obtained by applying the
%% Astroem and Haegglund rules [2].  These values are to be improved using a
%% numerical optimization as shown below.

%% As with all numerical methods, this approach can never guarantee that a
%% proposed solution is a global minimum.  Therefore, good initial guesses for
%% the parameters to be optimized are very important.
%% The Octave function @code{fminsearch} minimizes the objective function @var{J},
%% which is chosen to be
%% $$ J(k_p, T_i, T_d) = \\mu_1 \\cdot \\int_0^{\\infty} \\! t \\ |e(t)| \\ dt \\ + \\ \\mu_2 \\cdot (|| y(t) ||_{\\infty} - 1) \\ + \\ \\mu_3 \\cdot ||S(jw)||_{\\infty} $$
%% @example
%%                     inf 
%% J(Kp, Ti, Td) = mu1 INT t |e(t)| dt  +  mu2 (||y(t)||    - 1)  +  mu3 ||S(jw)||
%%                      0                               inf                       inf
%% This particular objective function penalizes the integral of time-weighted absolute error
%% $$ ITAE = \\int_0^{\\infty} \\! t \\ |e(t)| \\ dt $$
%% @example
%%        inf 
%% ITAE = INT t |e(t)| dt
%%         0             
%% and the maximum overshoot
%% $$ y_{max} - 1 = || y(t) ||_{\\infty} - 1 $$
%% @example
%% y    - 1 = ||y(t)||    - 1
%%  max               inf
%% to a unity reference step
%% $r(t) = \\varepsilon (t)$
%% in the time domain. In the frequency domain, the sensitivity
%% $$ M_s = ||S(jw)||_{\\infty} $$
%% @example
%% Ms = ||S(jw)||
%%               inf
%% is minimized for good robustness, where S(jw) denotes the @emph{sensitivity} transfer function
%% $$ S(s) = {1 \\over 1 + L(s)} = {1 \\over 1 + P(s) \\ C(s)} $$
%% @example
%%            1            1
%% S(s) = -------- = -------------
%%        1 + L(s)   1 + P(s) C(s)
%% The constants
%% $\\mu_1$, $\\mu_2$ and $\\mu_3$
%% mu1, mu2 and mu3
%% are @emph{relative weighting factors} or @guillemetleft{}tuning knobs@guillemetright{}
%% which reflect the importance of the different design goals. Varying these factors
%% corresponds to changing the emphasis from, say, high performance to good robustness.
%% The main advantage of this approach is the possibility to explore the tradeoffs of
%% the design problem in a systematic way.
%% In a first approach, all three design objectives are weigthed equally.
%% In subsequent iterations, the parameters
%% $\\mu_1 = 1$, $\\mu_2 = 10$ and $\\mu_3 = 20$
%% mu1 = 1, mu2 = 10 and mu3 = 20
%% are found to yield satisfactory closed-loop performance.  This controller results
%% in a system with virtually no overshoot and a phase margin of 64 degrees.
%%
%% @*@strong{References}@*
%% [1] Guzzella, L.
%% @cite{Analysis and Design of SISO Control Systems},
%% VDF Hochschulverlag, ETH Zurich, 2007@*
%% [2] Astroem, K. and Haegglund, T.
%% @cite{PID Controllers: Theory, Design and Tuning},
%% Second Edition,
%% Instrument Society of America, 1995


function [kp_opt,Ti_opt, Td_opt]=xoptiPID(kp,Ti,Td,P,t_sim,dt,mu_1,mu_2,mu_3)

% Global Variables
global P t dt mu_1 mu_2 mu_3

s=tf('s');

% Simulation Settings: PLANT-DEPENDENT!
t = 0 : dt : t_sim;     % Time Vector [s]

%Controller based on initial values
C_0 = optiPIDctrl (kp, Ti, Td);

% Initial Values
C_par_0 = [kp; Ti; Td];

% Optimization
warning ('optiPID: optimization starts, please be patient ...');
C_par_opt = fminsearch (@optiPIDfun, C_par_0);

% Optimized Controller
%disp ('optiPID: optimized PID controller parameters:');
kp_opt = C_par_opt(1);
Ti_opt = C_par_opt(2);
Td_opt = C_par_opt(3);

C_opt = optiPIDctrl (kp_opt, Ti_opt, Td_opt);

% Open Loop
L_0 = P * C_0;
L_opt = P * C_opt;

% Closed Loop
T_0 = feedback (L_0, 1);
T_opt = feedback (L_opt, 1);

% A Posteriori Stability Check
disp ('optiPID: closed-loop stability check:');
st_0 = isstable (T_0);
st_opt = isstable (T_opt);

% Stability Margins
%disp ('optiPID: gain margin gamma [-] and phase margin phi [deg]:');
[gamma_0, phi_0] = margin (L_0);
[gamma_opt, phi_opt] = margin (L_opt);

% Plot Step Response
figure(),
step (T_0, 'b', T_opt, 'r', t)
legend ('Initial PID', 'Optimized PID', 'Location', 'SouthEast')
refresh();

endfunction
% ===============================================================================




