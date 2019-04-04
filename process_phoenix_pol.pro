pro process_phoenix_pol

	; Like the Stokes I data, only some channels seem to be calibrated for Stokes V.

	!p.charsize=1.5
	t0=anytim('2003-11-18T07:50:00', /utim)
	t1=anytim('2003-11-18T09:00:00', /utim)
	bgt0=anytim('2003-11-18T08:25:00', /utim)
	bgt1=anytim('2003-11-18T08:35:00', /utim)

	files = findfile('~/Data/2003_nov_18/phoenix/PHOENIX*p.fit.gz')
	output_path='~/Data/2003_nov_18/phoenix/'

	for i=0, n_elements(files)-1 do begin
		print, 'Reading: '+files[i]
		radio_spectro_fits_read, files[i], data, time, freq, main_header=hdr

		if i eq 0 then begin
			data_V = data 
			times = time
		endif else begin
			data_V = [data_V, data]
			times = [times, time]
		endelse	

	endfor	


	data = data_V
	data_section = data[where(times gt bgt0 and times lt bgt1),*]
	pol_channels = where(data_section[0,*] lt -20.0 or data_section[0,*] gt 20.0)
	
	loadct, 0
	utplot, [t0, t1], [-100, 100], /xs, /ys, /nodata
	
	data_pol = data[*, pol_channels]
	freq = freq[pol_channels]


	indices = [0, 12, 18, 23] ; 2620, 1480, 408 MHz
	data_pol = data_pol[*, indices]
	freq = freq[indices]
	corrections = [60, 10, 26, 5]

	loadct, 74
	for i=0, n_elements(freq)-1 do begin

		flux = smooth(data_pol[*, i], 15) + corrections[i]
		outplot, times, flux, color=i*60.0
		print, freq[i]
	endfor

	save, times, data_pol, freq, corrections, $
		filename = output_path+'PHOENIX_2003118_V_processed.sav'
	;data = constbacksub(data, /auto)

stop
end	