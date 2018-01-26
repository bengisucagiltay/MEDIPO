package gui;

import bitmap.EditableImage;

import javax.swing.*;
import java.util.ArrayList;

public class TestFrame extends JFrame {

    private JPanel container;
    private JScrollPane scrollPane;
    private ArrayList<ImagePanel> panels;

    public TestFrame(ArrayList<EditableImage> images){
        super();

        container = new JPanel();
        panels = new ArrayList<>();

        createPanels(images);
        addPanels(images);

        scrollPane = new JScrollPane(container);
        setContentPane(scrollPane);

        pack();
        setVisible(true);
        setResizable(false);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }

    private void createPanels(ArrayList<EditableImage> images){
        for(int i = 0; i < images.size(); i++){
            panels.add(new ImagePanel(images.get(i)));
        }
    }

    private void addPanels(ArrayList<EditableImage> images){
        for(int i = 0; i < images.size(); i++){
            container.add(panels.get(i));
        }
    }
}
