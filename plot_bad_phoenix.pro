pro plot_bad_phoenix

	; Plot the unprocess PHOENIX spectrogram. In its raw form it appears only some channels are calibrated.
	; Will email C. Monstein about this.

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

	window, 0
	loadct, 3
	data_total = constbacksub(data_total, /auto)
	spectro_plot, sigrange(data_total), times, freq, $
		xrange = [t0, t1], $
		/xs, $
		/ys, $
		ytitle = 'Frequency (MHz)'


	data= congrid(data_total, 500, 500)  
	spectrum = data[250, *]

	window, 1
	plot, freq, spectrum, $
		xtitle = 'Frequency (MHz)', $
		ytitle = 'Intensity (Arbitrary Units)'
	stop
	

end	