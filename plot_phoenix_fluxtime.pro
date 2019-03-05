pro setup_ps, name
  
   set_plot,'ps'
   !p.font=0
   !p.charsize=1.0
   device, filename = name, $
          /color, $
          /helvetica, $
          /inches, $
          xsize=10, $
          ysize=12, $
          /encapsulate, $
          yoffset=5, $
          bits_per_pixel = 16

end




pro plot_phoenix_fluxtime, postscript=postscript

	!p.charsize=1.5
	t0=anytim('2003-11-18T07:00:00', /utim)
	t1=anytim('2003-11-18T09:30:00', /utim)
	bgt0=anytim('2003-11-18T08:25:00', /utim)
	bgt1=anytim('2003-11-18T08:35:00', /utim)

	output_path='/Users/eoincarley/Data/2003_nov_18/'
	restore, output_path+'phoenix/PHOENIX_2003118_processed.sav'

	;data = constbacksub(data, /auto)
	data = smooth(data, 2)

	if keyword_set(postscript) then begin	
		setup_ps, output_path+'phoenix_rstn_rhessi_20031118.eps'
	endif else begin
		loadct, 0
		!p.background=100
		!p.color=0
		window, 0, xs=1200, ys=1000
	endelse	

	position = [0.12, 0.15, 0.82, 0.5]
	loadct, 3
	spectro_plot, data > (1) < 100, times, freq, $
		/xs, $
		/ys, $
		/ylog, $
		yr = [100, 1e4], $
		ytitle = 'Frequency (MHz)', $
		xtitle = 'Time (UT)', $
		xr = [t0,t1], $
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

	xyouts, 0.735, 0.47, 'PHOENIX', /normal, color=1


	flux_1400 = data[*, (where(freq ge 1400))[0]]
	flux_1400 = smooth(flux_1400, 4)
	flux_1400 = 45*alog10(flux_1400 +10.0)


	utplot, times, flux_1400, /xs, /ys, $
		pos = [0.12, 0.51, 0.82, 0.7], $
		/noerase, $
		xr = [t0,t1]

	if keyword_set(postscript) then device, /close
	set_plot,'x'



stop
END