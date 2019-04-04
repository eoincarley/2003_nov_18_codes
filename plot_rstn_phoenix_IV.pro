pro setup_ps, name
  
   set_plot,'ps'
   !p.font=0
   !p.charsize=1.0
   device, filename = name, $
          /color, $
          /helvetica, $
          /inches, $
          xsize=9, $
          ysize=10, $
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
	rstnfile = '~/Data/2003_nov_18/RSTN/RSTN_flux_time_20031118.sav'
	pos0 = [0.15, 0.52, 0.95, 0.9]
	pos1 = [0.15, 0.13, 0.95, 0.51]
	t0 = anytim('2003-11-18T08:00:00', /utim) ; For data extraction. Related to data_start index.
	t1 = anytim('2003-11-18T09:00:00', /utim)
	xrange = [t0,t1]

	restore, rstnfile
	times = rstn_struct.times
	timsec = times - times[0]
	flux_410 = rstn_struct.flux_410
	flux_1415 = rstn_struct.flux_1415
	flux_2695 = rstn_struct.flux_2695
	flux_4995 = rstn_struct.flux_4995

	
	;-----------------------------;
	;
	;	 Plot RSTN intensity
	;	
	if keyword_set(postscript) then begin	
		setup_ps, output_path+'figures/rstn_phoenix_IV_20031118.eps'
	endif else begin
		loadct, 0
		!p.background=100
		!p.color=0
		window, 0, xs=800, ys=1200
		set_line_color
	endelse	

	utplot, timsec, flux_410, times[0], color=0, $
		ytitle = 'Flux (SFU)', $
		/xs, /ys, $
		/normal, $
		/noerase, $
		timerange = [t0, t1], $
		xticklen = 1.0, xgridstyle = 1.0, $
		thick = 4, $
		yrange = [10, 2e4], $
		/ylog, $
		position = pos0, $
		xtickformat = '(A1)', $
		xtitle=' '

	outplot, timsec, flux_410, times[0], color=4, thick = 3
	outplot, timsec, flux_1415, times[0], color=5, thick = 4
	outplot, timsec, flux_2695, times[0], color=6, thick = 4
	outplot, timsec, flux_4995, times[0], color=8, thick = 4

	legend, ['RSTN 410 MHz', '1415 MHz', '2695 MHz', '4995 MHz'], $
		colors = [4, 5, 6, 8], $
		linestyle = [0, 0, 0, 0], $
		box=0, $
		/top, /right

	;-------------------------------;
	;
	;	 Plot Phoenix Stokes I
	;	
	;files = findfile('~/Data/2003_nov_18/phoenix/PHOENIX*i.fit.gz')
	;output_path='/Users/eoincarley/Data/2003_nov_18/'

	;for i=0, n_elements(files)-1 do begin
	;	radio_spectro_fits_read, files[i], data, time, freq, main_hea=hdr
	;
	;	if i eq 0 then begin
	;		data_total = data 
	;		times = time
	;	endif else begin
	;		data_total = [data_total, data]
	;		times = [times, time]
	;	endelse	
	;
	;endfor	

	;phnx_1400 = data_total[*, (where(freq gt 1400))[-1]]
	;phnx_1400 = 10.0^(phnx_1400/45.0) - 10.0
	;timsec = times - times[0]
	;outplot, timsec, phnx_1400, times[0]
		
	;-------------------------------;
	;
	;	 Plot Phoenix Stokes V
	;	
	restore, phnx_path+'PHOENIX_2003118_V_processed.sav'
	timsec = times - times[0]
	cols = [8, 6, 5, 4]
	for i=0, n_elements(freq)-1 do begin
		flux = smooth(data_pol[*, i], 15) + corrections[i]
		if i eq 0 then begin
			utplot, timsec, flux, times[0], $
				color=0, $
				/xs, /ys, $
				timerange = [t0, t1], $
				position = pos1, $
				yr = [-100, 100], $
				ytitle = 'Stokes V (%)', $
				xtitle = 'Time (UT)', $
				xticklen = 1.0, xgridstyle = 1.0, $
				/noerase, $
				thick=3

			outplot, timsec, flux, times[0], color=cols[i], thick=2
		endif else begin
			outplot, timsec, flux, times[0], color=0, thick=3
			outplot, timsec, flux, times[0], color=cols[i], thick=2
		endelse	
		print, freq[i]
	endfor

	legend, ['PHOENIX 408 MHz', '1480 MHz', '2620 MHz', '3400 MHz'], $
		colors = [4, 5, 6, 8], $
		linestyle = [0, 0, 0, 0], $
		box=0, $
		/top, /right

	if keyword_set(postscript) then device, /close
	set_plot,'x'

stop
END