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

	timesec = time - time[0]
	utplot, timesec, flux, time[0], pos=position, color=col, xtickformat=xtickfmt, xtit=xtitle, $
		ytitle='Flux (SFU)', /xs, /ys, /normal, /noerase, timerange=xrange, $
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

pro plot_rhessi, t0, t1, position=position

	restore, '~/Data/2003_nov_18/RHESSI/rhessi_20011118.sav'
	data_0 = smooth(data_0, 10)
	data_1 = smooth(data_1, 10)
	data_2 = smooth(data_2, 10)
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
			yr = [20, 2e3], $
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

	legend, ['RHESSI 6-12 keV', 'RHESSI 12-25 keV', 'RHESSI 25-50 keV'], $
		color = [10, 8, 4], $
		linestyle = intarr(3), $
		box=0, $
		charsize=1.0, $
		textcolors = 0, $
		/left, $
		/normal, $
		thick=3					

	xyouts, position[0]+0.03, position[3]-0.015, 'RHESSI', /normal, color=col

end

pro plot_rstn_rhessi_flux, postscript=postscript
	
	; Code to plot up single frequency light curves.

	; Set up the position coords of each time series. Single column.

	ypos = 0.98
	plot_delt = 0.1
	del_inc = 0.006
	pos0 = [0.1, ypos-plot_delt, 0.93, ypos]
	pos1 = [0.1, ypos-plot_delt*2.0, 0.93, ypos-plot_delt - del_inc]
	pos2 = [0.1, ypos-plot_delt*3.0, 0.93, ypos-plot_delt*2.0- del_inc]
	pos3 = [0.1, ypos-plot_delt*4.0, 0.93, ypos-plot_delt*3.0- del_inc]
	pos4 = [0.1, ypos-plot_delt*5.0, 0.93, ypos-plot_delt*4.0- del_inc]
	pos5 = [0.1, ypos-plot_delt*6.0, 0.93, ypos-plot_delt*5.0- del_inc]
	pos6 = [0.1, ypos-plot_delt*7.0, 0.93, ypos-plot_delt*6.0- del_inc]

	plot_delt = 0.104
	pos7 = [0.1, ypos-plot_delt*8.0, 0.93, ypos-plot_delt*7.0- del_inc]
	pos8 = [0.1, ypos-plot_delt*9.0, 0.93, ypos-plot_delt*8.0- del_inc]
	set_line_color
	output_path='/Users/eoincarley/Data/2003_nov_18/'


	output_path='~/Data/2003_nov_18/'
	file = output_path+'RSTN/RSTN_flux_time_20031118.sav'
	restore, file
	times = rstn_struct.times

	t0 = anytim('2003-11-18T07:30:00', /utim)
	t1 = anytim('2003-11-18T09:00:00', /utim)
	xrange = [t0,t1]

	freqs = ['245', '410', '610', '1415', '2695', '4995', '8800', '15400']
	colors = [0,3,4,5,6,7,8,9]
	linestyle = [1,2,3,6,5,6,7,8,9]

	;--------------------------------;
	;
	;	  Plot RSTN intensity
	;	
	if keyword_set(postscript) then begin	
		setup_ps, output_path+'figures/rstn_rhessi_flux_20031118.eps'
	endif else begin
		loadct, 0
		!p.background=100
		!p.color=0
		window, 0, xs=800, ys=1200
		set_line_color
	endelse	

	plt_fmt, times, rstn_struct.flux_245, pos0, colors[0], freqs[0], xrange, xtickfmt='(A1)', xtitle=' ', yr=[1e1, 1.7e3], tag='a'
	plt_fmt, times, rstn_struct.flux_410, pos1, colors[1], freqs[1], xrange, xtickfmt='(A1)', xtitle=' ', yr=[1e1, 1.5e4], tag='b'
	plt_fmt, times, rstn_struct.flux_610, pos2, colors[2], freqs[2], xrange, xtickfmt='(A1)', xtitle=' ', yr=[1e1, 1.5e4], tag='c'
	plt_fmt, times, rstn_struct.flux_1415, pos3, colors[3], freqs[3], xrange, xtickfmt='(A1)', xtitle=' ', yr=[1e1, 1.5e4], tag='d'
	plt_fmt, times, rstn_struct.flux_2695, pos4, colors[4], freqs[4], xrange, xtickfmt='(A1)', xtitle=' ', yr=[1e2, 2.5e3], tag='e'
	plt_fmt, times, rstn_struct.flux_4995, pos5, colors[5], freqs[5], xrange, xtickfmt='(A1)', xtitle=' ', yr=[1e2, 2.5e3], tag='f'
	plt_fmt, times, rstn_struct.flux_15499, pos6, colors[6], freqs[7], xrange, xtickfmt='', xtitle='Time (UT)', yr=[1e2, 2.5e3], tag='g'


	t0plot = anytim('2003-11-18T08:05:00', /utim)
	t1plot = anytim('2003-11-18T08:35:00', /utim)
	plot_rhessi, t0plot, t1plot, position=pos7
	xyouts, pos7[0]+0.013, pos7[3]-0.013, 'h', /normal, color=0


	if keyword_set(postscript) then device, /close
	set_plot,'x'


END