pro plot_spec, data, time, freqs, frange, trange, scl0=scl0, scl1=scl1, plt_pos=plt_pos
	
	spectro_plot, data >scl0<scl1, $
  				time, $
  				freqs, $
  				/xs, $
  				/ys, $
  				/ylog, $
  				xtitle = ' ', $
  				ytitle = ' ', $
  				yr = [ frange[0], frange[1] ], $
  				timerange = [ trange[0], trange[1] ], $
  				/noerase, $
  				xtickformat = '(A1)', $
  				ytickformat = '(A1)', $
  				xticklen = -1e-5, $
  				yticklen = -1e-5, $
  				position = [0.1, 0.1, 0.9, 0.9], $
  				/normal
		  	
END

pro plot_ondrejov_20031118

	loadct, 0
	window, 0, xs=1000, ys=600
	!p.charsize=1.5

	time_start = anytim('2003-11-18T07:50:00', /utim)
	time_end = anytim('2003-11-18T08:50:00', /utim)
	scl0 = 10
	scl1 = 0.5e4
	frange = [5000, 100]

	file0='~/Data/2003_nov_18/ondrejov/RT5_20031118_075000_085500.fit'
	mreadfits, file0, hdr0, data0 
	data0 = reverse(data0, 2)
	;stop
	;data0 = constbacksub(data0, /auto)
	times0 = anytim('2003-11-18T'+hdr0.time_d$obs, /utim) + dindgen(hdr0.naxis1)*100e-3
	freqs0 = reverse(interpol([800, 2000], hdr0.naxis2))

	file1='~/Data/2003_nov_18/ondrejov/RT4_20031118_080100_085000.fit
	mreadfits, file1, hdr1, data1 
	data1 = reverse(data1, 2)
	;data1 = constbacksub(data1, /auto)
	times1 = anytim('2003-11-18T'+hdr1.time_d$obs, /utim) + dindgen(hdr1.naxis1)*100e-3
	freqs1 = reverse(interpol([2000, 4500], hdr1.naxis2))

	utplot, [time_start, time_end], frange, /nodata, /xs, /ys, yr=frange, xtitle = 'Time (UT)', $
  				ytitle = 'Frequency (MHz)', position = [0.1, 0.1, 0.9, 0.9]

	loadct, 74
	reverse_ct

	plot_spec, data0, times0, freqs0, frange, [time_start, time_end], scl0=scl0, scl1=scl1
	plot_spec, data1, times1, freqs1, frange, [time_start, time_end], scl0=scl0, scl1=scl1


  	cgColorbar, Range=[scl0, scl1], $
       OOB_Low='rose', OOB_High='charcoal', title='Flux (SFU)', /vertical, /right, $
       position = [0.925, 0.1, 0.937, 0.9 ], charsize=1.0, color=100, OOB_FACTOR=0.0, $
       /ylog, yticklen = -0.2
	

stop
END