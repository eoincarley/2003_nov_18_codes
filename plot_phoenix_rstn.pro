pro setup_ps, name
  
   set_plot,'ps'
   !p.font=0
   !p.charsize=1.0
   device, filename = name, $
          /color, $
          /helvetica, $
          /inches, $
          xsize=7, $
          ysize=5, $
          /encapsulate, $
          yoffset=5, $
          bits_per_pixel = 16

end

pro oplot_rstn, t0, t1, position=position

	;---------------------------------------------;
	;
	;			Over plot RSTN
	;
	output_path = '~/Data/2003_nov_18/RSTN/'
	file = output_path+'RSTN_flux_time_20031118.sav'
	restore, file
	times = rstn_struct.times
	timsec = times - times[0]
	xrange = [t0, t1]
	yrange = [1e1, 1e5]
	flux_1415 = rstn_struct.flux_1415

	set_line_color
	utplot, timsec, flux_1415, times[0], $
		position = position, $
		xtickformat='(A1)', $
		ytickformat='(A1)', $
		xtitle = ' ', $
		/xs, /ys, $
		color = 5, $
		timerange = [t0, t1], $
		/noerase, $
		/normal, $
		yr=yrange , $
		xticklen = -0.0001, $
		yticklen = -0.0001, $
		thick = 4, $
		/ylog

	axis, yaxis=1, yr=yrange, ytitle='RSTN Flux (SFU)', yticklen=-0.01, /ys

END


pro plot_phoenix_rstn, postscript=postscript

	!p.charsize=1.5
	t0=anytim('2003-11-18T08:23:00', /utim)
	t1=anytim('2003-11-18T08:23:30', /utim)
	output_path='/Users/eoincarley/Data/2003_nov_18/'
	restore, output_path+'phoenix/PHOENIX_2003118_processed.sav'

	data = constbacksub(data, /auto)
	;data = smooth(data, 2)

	if keyword_set(postscript) then begin	
		setup_ps, output_path+'figures/rstn_phoenix_20031118_zoom1.eps'
	endif else begin
		loadct, 0
		!p.background=100
		!p.color=0
		window, 0, xs=700, ys=500
	endelse	

	position = [0.12, 0.12, 0.92, 0.92]
	yrange = [600, 2e3]
	loadct, 74
	reverse_ct
	spectro_plot, data > (0.0) < 1.5, times, freq, $
		/xs, $
		/ys, $
		;/ylog, $
		yr = yrange, $
		ytitle = 'Frequency (MHz)', $
		xtitle = 'Time (UT)', $
		;xtickformat='(A1)', $
		xr = [t0, t1], $
		position = position

	set_line_color

	legend, ['RSTN San-Vito 1.4 GHz'], $
		color = [5], $
		linestyle = 0, $
		box=0, $
		charsize=1.0, $
		textcolors = 1, $
		/left, $
		/normal, $
		thick=3				
	;----------------------------------------;
	;
	;			Over plot RSTN
	;
	oplot_rstn, t0, t1, position = position

	if keyword_set(postscript) then device, /close
	set_plot, 'x'



stop
END