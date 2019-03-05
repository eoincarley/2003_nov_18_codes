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
	file = '~/Data/2003_nov_18/RSTN/18NOV03.LIS'
	time_base = anytim('2003-11-18T07:00:00', /utim)
	xrange=[t0,t1]
	
	result = read_ascii(file, data_start=4680)
	data = result.field1
	dshape = size(data)
	nseconds = dshape[2]
	nfreqs = dshape[1]
	times = time_base + findgen(nseconds)
	tindices = where(times ge t0 and times le t1)	
	flux_1415 = data[4, tindices]

	set_line_color
	utplot, times, flux_1415, $
		position = position, $
		xtickformat='(A1)', $
		ytickformat='(A1)', $
		xtitle = ' ', $
		/xs, /ys, $
		color = 5, $
		xr = [t0, t1], $
		/noerase, $
		/normal, $
		yr=[min(flux_1415), 1e5], $
		xticklen = -0.0001, $
		yticklen = -0.0001, $
		thick = 4, $
		/ylog

	axis, yaxis=1, yr=[min(flux_1415), 1e5], ytitle='RSTN Flux (SFU)', yticklen=-0.01, /ys

END


pro oplot_rhessi, t0, t1, position=position

	restore, '~/Data/2003_nov_18/RHESSI/rhessi_20011118.sav'
	data_0 = smooth(data_0, 10)
	data_1 = smooth(data_1, 10)
	data_2 = smooth(data_2, 10)
	t0_rhessi = anytim(t0, /atimes)
	t1_rhessi = anytim(t1, /atimes)
	yrange = [20, 2e3]
	utbase = anytim(t0, /utim)

	utplot, times_rate, data_0, utbase, $
			thick = 4, $
			color = 0, $
			/xs, $ 
			/ys, $
			/ylog, $
			xr=anytim([t0, t1], /utim), $
			yr = yrange, $
			xtitle='Time (UT)', $
			ytitle='RHESSI Count Rate (s!U-1!N detector!U-1!N)', $
			;xtickformat='(A1)', $
			;ytickformat='(A1)', $
			xticklen = 1.0, xgridstyle = 1.0, $
			;yticklen = 1.0, ygridstyle = 1.0, $
			position = position, $
			/noerase, $
			/normal

	outplot, times_rate, data_0, color=10, thick=3

	outplot, times_rate, data_1, color=0, thick=4
	outplot, times_rate, data_1, color=8, thick=3

	outplot, times_rate, data_2, color=0, thick=4
	outplot, times_rate, data_2, color=4, thick=3


	legend, ['RHESSI 6-12 keV', 'RHESSI 12-25 keV', 'RHESSI 25-50 keV'], $
		color = [10, 8, 4], $
		linestyle = intarr(3), $
		box=0, $
		charsize=1.0, $
		textcolors = 0, $
		/left, $
		/normal, $
		thick=3	

	;plot, times_rate, smooth(data_0, 5), /nodata, /ylog, XTICKFORMAT="(A1)", YTICKFORMAT="(A1)", yticklen=-1, pos = [0.929, 0.15, 0.93, 0.7], /normal, /noerase
	;axis, yaxis=1, yr=yrange, color=0, charsize=1.0, yticklen=-1e-1, ytitle='RHESSI Count Rate (s!U-1!N detector!U-1!N)', /ylog


end

pro plot_goes, t1, t2, plt_pos=plt_pos

	x1 = anytim(file2time(t1), /utim)
	x2 = anytim(file2time(t2), /utim)
	goes_obj = ogoes()
	goes_obj->set, tstart=anytim(t1, /yoh) , tend=anytim(t2, /yoh)
	low = goes_obj->getdata(/low) 
	high = goes_obj->getdata(/high) 
	times = goes_obj->getdata(/times)
	times = anytim(times, /utim)
	utbase = anytim('18-Nov-2003 07:00:00.000', /utim);goes_obj->get(/utbase)
	yrange = [1e-9, 1e-3]

	;--------------------------------;
	;			 Plot
	;
	set_line_color
	utplot, times, low, utbase, $
			thick = 3, $
			;tit = '1-minute GOES-15 Solar X-ray Flux', $
			ytit = 'Watts m!U-2!N', $
			xtit = 'Time (UT)', $
			color = 3, $
			xrange = [x1, x2], $
			;XTICKFORMAT="(A1)", $
			xticklen = 1.0, xgridstyle = 1.0, $
			yticklen = 1.0, ygridstyle = 1.0, $
			/xs, $
			yrange = yrange, $
			/ylog, $
			position = plt_pos, $
			/normal, $
			/noerase
	
			
	outplot, times, high, color=5, thick=3

	t0_rhessi = '2003-11-18T08:05'
	t1_rhessi = '2003-11-18T08:35'
	tvert0 = anytim([t0_rhessi, t0_rhessi], /utim) 
	tvert1 = anytim([t1_rhessi, t1_rhessi], /utim)
	outplot, tvert0, yrange, utbase, thick=3
	outplot, tvert1, yrange, utbase, thick=3
	
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
		setup_ps, output_path+'phoenix_rstn_rhessi_20031118.eps'
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
		linestyle = 0, $
		box=0, $
		charsize=1.0, $
		textcolors = 1, $
		/left, $
		/normal, $
		thick=3				

	loadct, 0
	t0_rhessi = '2003-11-18T08:05'
	t1_rhessi = '2003-11-18T08:35'
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
	plot_goes, t0, t1, plt_pos = position


	;----------------------------------------;
	;
	;			Over plot RHESSI
	;
	position = [0.12, 0.1, 0.82, 0.32]
	t0=anytim('2003-11-18T08:05:00', /utim)
	t1=anytim('2003-11-18T08:35:00', /utim)
	oplot_rhessi, t0, t1, position = position

	xyouts, 0.735, 0.875, 'PHOENIX', /normal, color=1

	if keyword_set(postscript) then device, /close
	set_plot,'x'



stop
END