pro setup_ps, name
  
   set_plot,'ps'
   !p.font=0
   !p.charsize=1.8
   device, filename = name, $
          /color, $
          /helvetica, $
          /inches, $
          xsize=8, $
          ysize=8, $
          /encapsulate, $
          yoffset=5, $
          bits_per_pixel = 16

end

pro plt_fmt, time, flux, position, col, freq, xrange, xtickfmt=xtickfmt, xtitle=xtitle
	
	dxlabel = 0.12

	utplot, time, flux, pos=position, color=col, xtickformat=xtickfmt, xtit=xtitle, $
		ytitle='Flux (SFU)', /xs, /ys, /normal, /noerase, xrange=xrange, $
		xticklen = 1.0, xgridstyle = 1.0, thick=4

	xyouts, position[2]-dxlabel, position[3]-0.02, freq+' MHz', /normal, color=col

end

pro plot_rstn_flux_spectrum, t0, t1, eps_name, postscript=postscript
	
	; Code to plot up single frequency light curves.

	; Set up the position coords of each time series. Single column.

	set_line_color
	t0 = anytim(t0, /utim)
	t1 = anytim(t1, /utim)
	output_path = '~/Data/2003_nov_18/'
	file = output_path+'RSTN/RSTN_flux_time_20031118.sav'
	restore, file
	times = rstn_struct.times
	timsec = times - times[0]
	xrange = [t0, t1]
	yrange = [1e1, 1e5]
	data = [transpose(rstn_struct.flux_245), $
			transpose(rstn_struct.flux_410), $
			transpose(rstn_struct.flux_610), $
			transpose(rstn_struct.flux_1415), $
			transpose(rstn_struct.flux_2695), $
			transpose(rstn_struct.flux_4995), $
			transpose(rstn_struct.flux_8800), $
			transpose(rstn_struct.flux_15499) ]

	for i=0, 7 do data[i,*] = data[i,*] - mean(data[i,-300:-1], /nan)
	tindices = where(times ge t0 and times le t1)
	data = data[*, tindices]
	freqs_str = ['245', '410', '610', '1415', '2695', '4995', '8800', '15400']
	freqs = float(freqs_str)

	if keyword_set(postscript) then begin	
		setup_ps, output_path + 'figures/' + eps_name
	endif else begin
		loadct, 0
		!p.background=100
		!p.color=0
		window, 0, xs=800, ys=800
	endelse	

	loadct, 0
	plot, freqs, data[*, 0], psym=8, $
				/xs, $
				/ys, $
				/ylog, $
				/xlog, $
				xtitle = 'Frequency (MHz)', $
				ytitle = 'Flux (SFU)', $
				symsize=1, $
				yr = [20, 2e4], $
				xr = [1e2, 3e4], $
				/nodata

	plotsym, 0
	colors = interpol([0,255], n_elements(tindices))

	for i=0, n_elements(tindices)-1, 180 do begin

		loadct, 0, /silent
		oplot, freqs, data[*, i], linestyle=2, color=50, thick = 6
		loadct, 74, /silent
		oplot, freqs, data[*, i], linestyle=2, color=colors[i], thick = 4

		loadct, 0, /silent
		oplot, freqs, data[*, i], psym=8, color=0, symsize=1, thick = 6
		loadct, 74, /silent
		oplot, freqs, data[*, i], psym=8, color=colors[i], symsize=1, thick = 4


		xyouts, freqs[0]-20, data[0, i], anytim(times[tindices[i]], /cc, /tim, /trun)+' UT', $
			color=colors[i], alignment=1, /data, charsize=0.8

	endfor	


	if keyword_set(postscript) then device, /close
	set_plot,'x'

END