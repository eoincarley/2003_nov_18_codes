pro setup_ps, name
  
   set_plot,'ps'
   !p.font=0
   !p.charsize=2.0
   device, filename = name, $
          /color, $
          /helvetica, $
          /inches, $
          xsize=7, $
          ysize=6, $
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

pro plot_rstn_flux_spectrum_v2, t0, t1, t2, eps_name, postscript=postscript
	
	; Code to plot up single frequency light curves.

	; Set up the position coords of each time series. Single column.

	; v2 plots specific times.

	set_line_color
	t0 = anytim(t0, /utim)
	t1 = anytim(t1, /utim)
	t2 = anytim(t2, /utim)
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

	tindices0 = ( where(times ge t0) )[0]
	tindices1 = ( where(times ge t1) )[0]
	tindices2 = ( where(times ge t2) )[0]

	tindices = [tindices0, tindices1, tindices2]

	data = data[*, tindices]			
	plotsym, 0
	colors = interpol([0,255], n_elements(tindices))
	linestyle = [0,2,4]
	
	for i=0, n_elements(tindices)-1 do begin

		loadct, 49, /silent
		oplot, freqs, data[*, i], linestyle=linestyle[i], color=200, thick = 6
		loadct, 0, /silent
		oplot, freqs, data[*, i], psym=8, color=0, thick = 6, symsize=1

		;xyouts, freqs[0]-20, data[0, i], anytim(times[tindices[i]], /cc, /tim, /trun)+' UT', $
		;	color=0, alignment=1, /data, charsize=1.2

	endfor	


	if keyword_set(postscript) then device, /close
	set_plot,'x'

END