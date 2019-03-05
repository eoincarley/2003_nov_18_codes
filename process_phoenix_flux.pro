pro process_phoenix_flux

	; Only some channels of phoenix appear to be calibrated.
	; This code extracts these channels.

	; Not sure who accurately the SFUs are calculated. They seem to be slightly different to RSTN.

	!p.charsize=1.5
	t0=anytim('2003-11-18T07:30:00', /utim)
	t1=anytim('2003-11-18T09:00:00', /utim)
	bgt0=anytim('2003-11-18T08:25:00', /utim)
	bgt1=anytim('2003-11-18T08:35:00', /utim)

	files = findfile('~/Data/2003_nov_18/phoenix/PHOENIX*i.fit.gz')
	output_path='/Users/eoincarley/Data/2003_nov_18/'

	for i=0, n_elements(files)-1 do begin
		radio_spectro_fits_read, files[i], data, time, freq, main_hea=hdr

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
	times = times[where(times gt bgt0 and times lt bgt1)]
	calib_channels = where(data_section[0,*] gt 140)

	loadct, 0
	utplot, [t0, t1], [1, 1e4], /xs, /ys, /nodata, /ylog

	data_sfu = 10.0^(data[*, calib_channels]/45.0) - 10.0
	freq = freq[calib_channels]
	loadct, 74
	for i=0, n_elements(freq)-1,2 do begin

		flux = smooth(data_sfu[*, i], 2)
		outplot, times, flux, color=i*50.0
		print, freq[i]

	endfor


stop
end	