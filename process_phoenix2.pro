pro process_phoenix2

	!p.charsize=1.5
	t0=anytim('2003-11-18T07:30:00', /utim)
	t1=anytim('2003-11-18T09:00:00', /utim)
	bgt0=anytim('2003-11-18T08:25:00', /utim)
	bgt1=anytim('2003-11-18T08:35:00', /utim)

	files = findfile('~/Data/2003_nov_18/phoenix/PHOENIX*i.fit.gz')
	output_path='/Users/eoincarley/Data/2003_nov_18/'

	for i=0, n_elements(files)-1 do begin
		radio_spectro_fits_read, files[i], data, time, freq, hdr=hdr

		if i eq 0 then begin
			data_total = data 
			times = time
		endif else begin
			data_total = [data_total, data]
			times = [times, time]
		endelse	

	endfor	


	
	; Some of the channels seem to have way higher values than others.
	; The following loop makes the large value channels more similar to the adjacent ones.
	data = data_total
	data_section = data[where(times gt bgt0 and times lt bgt1),*]
	bad_channels = where(data_section[0,*] lt 110)
	
	set_line_color
	for i=52000, n_elements(times)-1 do begin
		spectrum=data[i, *]
		plot, spectrum, yr=[10,200], xtitle=anytim(times[i], /cc)
		spectrum[bad_channels] = spectrum[bad_channels]*1.3
		oplot, spectrum, color=5
		wait, 0.00001


		stop
		;for j=0, n_elements(spectrum) do begin
		;	flux0 = spectrum[j]
		;	flux1 = spectrum[j+1]
		;	diff = flux1 - flux0
		;	if diff lt (-10) then begin
		;		flux1 = flux1*(flux0/flux1)
		;		spectrum[j+1] = flux1
		;	endif
		;	oplot, spectrum, color=5	
		;endfor
		;stop
		;data[i, 0] = spectrum
	endfor	

	for i=0, n_elements(times)-1 do data[i,*] = smooth(data[i,*], 2, /edge_mirror) 
	data = alog10(data)
	save, data, times, freq, filename=output_path+'phoenix/PHOENIX_2003118_processed.sav'
	;data = constbacksub(data, /auto)


end	