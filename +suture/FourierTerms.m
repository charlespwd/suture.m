classdef FourierTerms
  % FOURIERTERMS  A set of rectangular Fourier coefficients
  %
  %   FT = FourierTerms(As, Bs)
  %
  %   Note: As and Bs start with k = 0!!
  %
  % Suggested readings paper:
  %   Zahn, Charles, "Fourier Descriptors for Plane Closed Curves.", 1972

  properties
    cos_terms,    % A = {A_k}
    sin_terms,    % B = {B_k}
    truncation_length,      % N
  end

  methods
    function FT = FourierTerms(As, Bs)
      if (length(As) ~= length(Bs))
        error('As and Bs should have the same length');
      end
      FT.cos_terms = As;
      FT.sin_terms = Bs;
      FT.truncation_length = length(As) - 1;
    end
  end
end

