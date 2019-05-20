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
		linestyle = 5, $
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

pro oplot_rhessi, t0, t1, position=position, rtimes=rtimes, rlfux=rflux

	restore, '~/Data/2003_nov_18/RHESSI/rhessi_20011118.sav'
	data_0 = smooth(data_0, 5)
	data_1 = smooth(data_1, 5)
	data_2 = smooth(data_2, 5)
	t0_rhessi = anytim(t0, /atimes)
	t1_rhessi = anytim(t1, /atimes)

	timsec= times_rate - times_rate[0]

	set_line_color

	en_index = 1
	utplot, timsec, data_0, times_rate[0], $
			thick=5, $
			/xs, $ 
			/ys, $
			/ylog, $
			timerange = anytim([t0, t1], /utim), $
			yr = [10, 2e3], $
			xtitle='Time (UT)', $
			ytitle='Count Rate (s!U-1!N detector!U-1!N)', $
			color=0, $
			pos = position, $
			/noerase, $
			/normal, $
			xticklen = 1.0, xgridstyle = 1.0

	outplot, timsec, data_0, times_rate[0], color=10, thick=4
	outplot, timsec, data_1, times_rate[0], color=8, thick=5
	outplot, timsec, data_2, times_rate[0], color=4, thick=5

	goes_obj = ogoes()
	goes_obj->set, tstart=anytim(t0, /yoh) , tend=anytim(t1, /yoh)
	low = goes_obj->getdata(/low) 
	times = goes_obj->getdata(/times)
	
	;-------------------------;
	;		Oplot GOES
	;
	utplot, times, low/max(low), t1, color=3, thick=1, $
		pos = position, $
		xtickformat = '(A1)', $
		ytickformat = '(A1)', $
		yr=[0.1, 1.02], $
		yticklen = -1e-5, $
		xtitle = ' ', $
		/noerase

	;-------------------------;
	;		Oplot RSTN
	;
	output_path = '~/Data/2003_nov_18/RSTN/'
	file = output_path+'RSTN_flux_time_20031118.sav'
	restore, file
	times = rstn_struct.times
	timsec = times - times[0]
	xrange = [t0, t1]
	yrange = [1e1, 1e5]
	flux_1415 = rstn_struct.flux_1415

	nflux = flux_1415/max(flux_1415) -0.005
	set_line_color
	utplot, timsec, nflux, times[0], $
		color = 5, $
		pos = position, $
		linestyle = 5, $
		xtickformat = '(A1)', $
		ytickformat = '(A1)', $
		yr = [0.001, 1.1], $
		yticklen = -1e-5, $
		xtitle = ' ', $
		timerange = [t0, t1], $
		/noerase, $
		/ylog

	;-------------------------;
	;		Legend
	;
	legend, ['RHESSI 6-12 keV', 'RHESSI 12-25 keV', 'RHESSI 25-50 keV', 'GOES 0.1-0.8 nm', 'RSTN 1.4 GHz'], $
		color = [10, 8, 4, 3, 5], $
		linestyle = [0,0,0,0,5], $
		box=0, $
		charsize=1.0, $
		textcolors = 0, $
		/left, $
		/normal, $
		thick=3					

	xyouts, position[0]+0.03, position[3]-0.015, 'RHESSI', /normal, color=col

end

pro plot_goes, t1, t2, plt_pos=plt_pos, times=times, low=low

	goes_obj = ogoes()
	goes_obj->set, tstart=anytim(t1, /yoh) , tend=anytim(t2, /yoh)
	low = goes_obj->getdata(/low) 
	high = goes_obj->getdata(/high) 
	times = goes_obj->getdata(/times)
	yrange = [1e-9, 1e-3]

	;--------------------------------;
	;			 Plot
	;
	set_line_color
	utplot, times, low, t1, $
			thick = 3, $
			;tit = '1-minute GOES-15 Solar X-ray Flux', $
			ytit = 'Watts m!U-2!N', $
			xtit = 'Time (UT)', $
			color = 3, $
			timerange = anytim([t1, t2], /utim), $
			;XTICKFORMAT="(A1)", $
			xticklen = 1.0, xgridstyle = 1.0, $
			yticklen = 1.0, ygridstyle = 1.0, $
			/xs, $
			yrange = yrange, $
			/ylog, $
			position = plt_pos, $
			/normal, $
			/noerase
	
			
	outplot, times, high, t1, color=5, thick=3

	t0_rhessi = '2003-11-18T08:00'
	t1_rhessi = '2003-11-18T08:50'
	tvert0 = anytim([t0_rhessi, t0_rhessi], /utim) -  t1
	tvert1 = anytim([t1_rhessi, t1_rhessi], /utim) -  t1
	outplot, tvert0, yrange, t1, thick=3
	outplot, tvert1, yrange, t1, thick=3
	
	axis, yaxis=1, ytickname=[' ','A','B','C','M','X',' ']
	axis, yaxis=0, yrange=[1e-9, 1e-3]
	
			
	legend, ['GOES 0.1-0.8nm','GOES 0.05-0.4nm'], $
			linestyle=[0,0], $
			color=[3,5], $
			box=0, $
			pos = [0.12, plt_pos[3]-0.0025], $
			/normal, $
			charsize=1, $
			thick=3
			

	;xyouts, 0.925, 0.96, 'a', /normal		

END

pro plot_phoenix_rstn_rhessi_goes, postscript=postscript

	!p.charsize=1.5
	t0=anytim('2003-11-18T07:00:00', /utim)
	t1=anytim('2003-11-18T09:30:00', /utim)
	bgt0=anytim('2003-11-18T08:25:00', /utim)
	bgt1=anytim('2003-11-18T08:35:00', /utim)

	output_path='/Users/eoincarley/Data/2003_nov_18/'
	restore, output_path+'phoenix/PHOENIX_2003118_processed.sav'

	data = constbacksub(data, /auto)
	data = smooth(data, 2)

	if keyword_set(postscript) then begin	
		setup_ps, output_path+'figures/rstn_phoenix_rhessi_goes_20031118.eps'
	endif else begin
		loadct, 0
		!p.background=100
		!p.color=0
		window, 0, xs=1200, ys=1000
	endelse	

	position = [0.12, 0.57, 0.82, 0.92]
	yrange = [100, 1e4]
	loadct, 3
	spectro_plot, data > (-0.01) < 1, times, freq, $
		/xs, $
		/ys, $
		/ylog, $
		yr = yrange, $
		ytitle = 'Frequency (MHz)', $
		xtitle = ' ', $
		xtickformat='(A1)', $
		xr = [t0, t1], $
		position = position


	set_line_color

	legend, ['RSTN San-Vito 1.4 GHz'], $
		color = [5], $
		linestyle = 5, $
		box=0, $
		charsize=1.0, $
		textcolors = 1, $
		/left, $
		/normal, $
		thick=3				

	loadct, 0
	t0_rhessi = '2003-11-18T08:00'
	t1_rhessi = '2003-11-18T08:50'
	tvert0 = anytim([t0_rhessi, t0_rhessi]) 
	tvert1 = anytim([t1_rhessi, t1_rhessi])
	outplot, tvert0, yrange, thick=3, color=150
	outplot, tvert1, yrange, thick=3, color=150
					
	set_line_color
	;----------------------------------------;
	;
	;			Over plot RSTN
	;
	oplot_rstn, t0, t1, position = position

	;----------------------------------------;
	;
	;			Plot GOES
	;
	position = [0.12, 0.37, 0.82, 0.56]
	plot_goes, t0, t1, plt_pos = position, times=gtimes, low=gflux


	;----------------------------------------;
	;
	;			Over plot RHESSI
	;
	position = [0.12, 0.1, 0.82, 0.32]
	t0=anytim(t0_rhessi, /utim)
	t1=anytim(t1_rhessi, /utim)
	oplot_rhessi, t0, t1, position = position

	xyouts, 0.735, 0.89, 'PHOENIX', /normal, color=1

	if keyword_set(postscript) then device, /close
	set_plot,'x'



stop
END