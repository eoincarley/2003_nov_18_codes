pro setup_ps, name
  
   set_plot,'ps'
   !p.font=0
   !p.charsize=1.0
   device, filename = name, $
          /color, $
          /helvetica, $
          /inches, $
          xsize=9, $
          ysize=13, $
          /encapsulate, $
          yoffset=5, $
          bits_per_pixel = 16

end

pro plt_fmt, time, flux, position, col, freq, xrange, xtickfmt=xtickfmt, xtitle=xtitle, yrange=yrange, tag=tag
	
	dxlabel = 0.2

	utplot, time, flux, pos=position, color=col, xtickformat=xtickfmt, xtit=xtitle, $
		ytitle='Flux (SFU)', /xs, /ys, /normal, /noerase, xrange=xrange, $
		xticklen = 1.0, xgridstyle = 1.0, thick=4, yrange=yrange

	t0_rhessi = '2003-11-18T08:05'
	t1_rhessi = '2003-11-18T08:35'
	tvert0 = anytim([t0_rhessi, t0_rhessi]) 
	tvert1 = anytim([t1_rhessi, t1_rhessi])
	outplot, tvert0, yrange, thick=3
	outplot, tvert1, yrange, thick=3
	

	xyouts, position[2]-dxlabel, position[3]-0.02, 'RSTN SV '+freq+' MHz', /normal, color=col
	xyouts, position[0]+0.013, position[3]-0.013, tag, /normal, color=0


end



pro plot_rstn_phoenix_IV, postscript=postscript
	
	; Code to plot up single frequency light curves.

	; Set up the position coords of each time series. Single column.

	set_line_color
	output_path='~/Data/2003_nov_18/'
	phnx_path = '~/Data/2003_nov_18/phoenix/'
	rstnfile = '~/Data/2003_nov_18/RSTN/18NOV03.LIS'
	pos0 = [0.15, 0.52, 0.95, 0.9]
	pos1 = [0.15, 0.12, 0.95, 0.5]
	t0 = anytim('2003-11-18T08:00:00', /utim) ; For data extraction. Related to data_start index.
	t1 = anytim('2003-11-18T09:00:00', /utim)
	
	time_base = anytim('2003-11-18T07:30:00', /utim)
	result = read_ascii(rstnfile, data_start=6393)
	data = result.field1
	dshape = size(data)
	nseconds = dshape[2]
	nfreqs = dshape[1]
	times = time_base + dindgen(nseconds)
	tindices = where(times ge t0 and times le t1)

	times = times[tindices]
	timsec = times - times[0]
	flux_410 = data[2, tindices]  ;- data[2, -1] 
	flux_1415 = data[4, tindices] ;- data[4, -1]
	flux_2695 = data[5, tindices] ;- data[5, -1]
	
	;-----------------------------;
	;
	;	 Plot RSTN intensity
	;	
	if keyword_set(postscript) then begin	
		setup_ps, output_path+'rstn_phoenix_flux_20031118.eps'
	endif else begin
		loadct, 0
		!p.background=100
		!p.color=0
		window, 0, xs=800, ys=1200
		set_line_color
	endelse	

	flux_1415 = alog10(flux_1415)
	utplot, timsec, flux_1415/max(flux_1415), t0, color=3, $
		ytitle='Flux (SFU)', $
		/xs, /ys, $
		/normal, $
		/noerase, $
		timerange = [t0, t1], $
		xticklen = 1.0, xgridstyle = 1.0, $
		thick=4, $
		;yrange=[10, 2e4], $
		;/ylog, $
		position=pos0;, $
		;xtickformat='(A1)', $
		;xtitle=' '

	;outplot, times, flux_1415, color=5
	;outplot, times, flux_2695, color=6

	stop
	;-------------------------------;
	;
	;	 Plot Phoenix Stokes I
	;	
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

	phnx_1400 = data_total[*, (where(freq gt 1400))[-1]]
	phnx_1400 = phnx_1400/max(phnx_1400) - 0.3
	timsec = times - times[0]
	outplot, timsec - 2.0*60.0, phnx_1400, times[0]
		
	STOP
	;-------------------------------;
	;
	;	 Plot Phoenix Stokes V
	;	

	restore, phnx_path+'PHOENIX_2003118_V_processed.sav'
	cols = [0, 6, 5, 3]
	for i=1, n_elements(freq)-1 do begin
		flux = smooth(data_pol[*, i], 15) + corrections[i]
		if i eq 1 then begin
			utplot, times, flux, t0, $
				color=cols[i], $
				/xs, /ys, $
				xrange=[t0,t1], $
				position=pos1, $
				yr = [-100, 100], $
				xticklen = 1.0, xgridstyle = 1.0, $
				/noerase
		endif else begin
			outplot, times, flux, color=cols[i]
		endelse	
		print, freq[i]
	endfor



	if keyword_set(postscript) then device, /close
	set_plot,'x'

stop
END